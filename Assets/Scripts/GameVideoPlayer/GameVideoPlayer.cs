
#define LUACOMPILE

#if LUACOMPILE
using LuaInterface;
#endif

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class GameVideoPlayer : MonoBehaviour
{

    private static GameVideoPlayer instance;

    private VideoPlayer player;
    private AudioSource soundPlayer;
    private Camera videoCamera;
    private VideoClip clip;
    private GameObject playerObj;

    public delegate void VideoEventHandler(VideoPlayer source);

    public VideoEventHandler VideoCompleted;
    public VideoEventHandler SeekCompleted;
    public VideoEventHandler PrepareCompleted;
    public VideoEventHandler Started;
#if LUACOMPILE
    private LuaFunction luaOnVideoCompleted = null;
    private LuaFunction luaOnSeekCompleted = null;
    private LuaFunction luaOnPrepareCompleted = null;
    private LuaFunction luaOnStarted = null;
#endif
    private RenderTexture mRenderTexture = null;
    private bool autoTextureMode = false;

    private int renderWidth = -1;
    private int renderHeight = -1;
    private int renderDepth = 24;

    private RenderTextureFormat renderTextureFormat = RenderTextureFormat.ARGB32;
    private RenderTextureReadWrite renderTextureRW = RenderTextureReadWrite.sRGB;

    public static GameVideoPlayer Instance()
    {
        if (instance == null)
        {
            instance = new GameObject("GameVideoPlayer").AddComponent<GameVideoPlayer>();
            instance.playerObj = instance.gameObject;
            GameObject.DontDestroyOnLoad(instance.playerObj);
        }
        return instance;
    }

    public void Init()
    {
        if (instance == null)
        {
            instance = this;
        }
        if (playerObj == null)
        {
            if (instance != null)
            {
                instance.gameObject.name = "GameVideoPlayer";
                playerObj = instance.gameObject;
            }
            GameObject.DontDestroyOnLoad(playerObj);
        }
        player = playerObj.AddComponent<VideoPlayer>();
        soundPlayer = playerObj.AddComponent<AudioSource>();
        player.playOnAwake = false;
        player.SetTargetAudioSource(0, soundPlayer);
        player.renderMode = VideoRenderMode.CameraNearPlane;
        player.isLooping = false;
        soundPlayer.loop = false;
        soundPlayer.playOnAwake = false;
        soundPlayer.mute = false;
        player.waitForFirstFrame = true;
        player.loopPointReached += _LoopPointReached;
        player.prepareCompleted += _PrepareCompleted;
        player.seekCompleted += _SeekCompleted;
        player.started += _Started;
        if (videoCamera != null)
        {
            player.targetCamera = videoCamera;
        }
        else
        {
            videoCamera = Camera.main;
            player.targetCamera = videoCamera;
        }
    }

    public RenderTexture GetRenderTexture()
    {
        return mRenderTexture;
    }
    public void SetRenderTexture(RenderTexture tex)
    {
        mRenderTexture = tex;
        player.targetTexture = mRenderTexture;
    }
    public void SetPlaybackSpeed(float speed)
    {
        player.playbackSpeed = speed;
    }
    public float GetPlaybackSpeed()
    {
        return player.playbackSpeed;
    }
    public void SetFrame(long frame)
    {
        player.frame = frame;
    }
    public long GetFrame()
    {
        return player.frame;
    }
    public void SetClip(VideoClip mClip)
    {
        clip = mClip;
        player.clip = clip;
    }
    public VideoClip GetClip()
    {
        return clip;
    }
    public void SetSkipOnDrop(bool skip)
    {
        player.skipOnDrop = skip;
    }
    public void SetVideoAlpha(float alpha)
    {
        player.targetCameraAlpha = alpha;
    }

    public void SetMaterialOverrideMode(MeshRenderer render, string materialProperty)
    {
        player.renderMode = VideoRenderMode.MaterialOverride;
        player.targetMaterialRenderer = render;
        player.targetMaterialProperty = materialProperty;
        autoTextureMode = false;
    }

    public void SetCameraPlaneMode(Camera mCamera, bool far, float alpha, int ratio)
    {
        if (far)
            player.renderMode = VideoRenderMode.CameraFarPlane;
        else
            player.renderMode = VideoRenderMode.CameraNearPlane;
        if (mCamera == null)
        {
            mCamera = Camera.main;
        }
        videoCamera = mCamera;
        player.targetCamera = mCamera;
        player.targetCameraAlpha = alpha;
        player.aspectRatio = (VideoAspectRatio)ratio;
        autoTextureMode = false;
    }

    public void SetRenderTextureMode(Camera mCamera, RenderTexture targetTexture, int ratio)
    {
        player.renderMode = VideoRenderMode.RenderTexture;
        videoCamera = mCamera;
        player.targetCamera = mCamera;
        player.aspectRatio = (VideoAspectRatio)ratio;
        mRenderTexture = targetTexture;
        player.targetTexture = mRenderTexture;
        autoTextureMode = false;
    }

    public void SetRenderTextureModeAutoTexture(int ratio)
    {
        player.renderMode = VideoRenderMode.RenderTexture;
        player.aspectRatio = (VideoAspectRatio)ratio;
        if (mRenderTexture != null)
        {
            Object.DestroyImmediate(mRenderTexture);
        }
        mRenderTexture = null;
        autoTextureMode = true;
    }

    public void Play()
    {
        if (autoTextureMode && mRenderTexture == null)
        {
            if (renderWidth <= -1 || renderHeight <= -1)
            {
                mRenderTexture = RenderTexture.GetTemporary(Screen.width, Screen.height, 24, renderTextureFormat, renderTextureRW);
            }
            else
            {
                mRenderTexture = RenderTexture.GetTemporary(renderWidth, renderHeight, renderDepth, renderTextureFormat, renderTextureRW);
            }
        }
        if(autoTextureMode)
            SetRenderTexture(mRenderTexture);
        player.Play();
    }
    public void Stop()
    {
        if (autoTextureMode && mRenderTexture != null)
        {
            RenderTexture.ReleaseTemporary(mRenderTexture);
        }
        player.Stop();
      
    }
    public void Pause()
    {
        player.Pause();
    }
    public void Prepare()
    {
        player.Prepare();
    }
    public void Skip()
    {
        _LoopPointReached(player);
    }
    public void SetVolume(float vol)
    {
        soundPlayer.volume = vol;
    }
    public void Mute(bool m)
    {
        soundPlayer.mute = m;
    }
    public void SetplaybackSpeed(float speed)
    {
        player.playbackSpeed = speed;
    }
    public float GetplaybackSpeed()
    {
        return player.playbackSpeed;
    }
    public VideoPlayer GetPlayer()
    {
        return player;
    }
    public double GetTime()
    {
        return player.time;
    }
    public void SetRenderTextureSize(int w, int h,int d)
    {
        renderWidth = w;
        renderHeight = h;
        renderDepth = d;
    }
    public void SetRenderTextureSize(int w, int h, int d, int  format, bool isSRGB)
    {
        renderWidth = w;
        renderHeight = h;
        renderDepth = d;
        renderTextureFormat = (RenderTextureFormat)format;
        renderTextureRW = isSRGB ? RenderTextureReadWrite.sRGB : RenderTextureReadWrite.Linear;
    }
    public void SetTime(double mTine)
    {
        player.time = mTine;
    }
    public void SetCamera(Camera mCamera)
    {
        player.targetCamera = mCamera;
    }
    public void SetUrlMode(string url)
    {
        //设置为URL模式  
        player.source = VideoSource.Url;
        //设置播放路径  
        player.url = url;
    }
#if LUACOMPILE
    public void SetLuaCallBack(LuaFunction prepareCompleted, LuaFunction videoCompleted, LuaFunction seekCompleted, LuaFunction started)
    {
        luaOnPrepareCompleted = prepareCompleted;
        luaOnVideoCompleted = videoCompleted;
        luaOnSeekCompleted = seekCompleted;
        luaOnStarted = started;
    }
#endif
    public void _Started(VideoPlayer source)
    {
        Debug.Log("_Started");
        if (Started != null)
        {
            Started.Invoke(source);
        }
#if LUACOMPILE
        if (luaOnSeekCompleted != null)
            GameBase.LuaManager.CallFunc_VX(luaOnStarted, source);
#endif
    }
    public void _SeekCompleted(VideoPlayer source)
    {
        Debug.Log("SeekCompleted");
        if (SeekCompleted != null)
        {
            SeekCompleted.Invoke(source);
        }
#if LUACOMPILE
        if (luaOnSeekCompleted != null)
            GameBase.LuaManager.CallFunc_VX(luaOnSeekCompleted, source);
#endif
    }
    public void _LoopPointReached(VideoPlayer source)
    {
        Debug.Log("LoopPointReached");
        Debug.Log("VideoCompleted");
        Stop();
        if (VideoCompleted != null)
        {
            VideoCompleted.Invoke(source);
        }
#if LUACOMPILE
        if (luaOnVideoCompleted != null)
            GameBase.LuaManager.CallFunc_VX(luaOnVideoCompleted, source);
#endif
    }
    public void _PrepareCompleted(VideoPlayer source)
    {
        Debug.Log("PrepareCompleted");
        if (PrepareCompleted != null)
        {
            PrepareCompleted.Invoke(source);
        }
#if LUACOMPILE
        if (luaOnPrepareCompleted != null)
            GameBase.LuaManager.CallFunc_VX(luaOnPrepareCompleted, source);
#endif

    }

    private void OnDestroy()
    {
        Stop();
    }
}
