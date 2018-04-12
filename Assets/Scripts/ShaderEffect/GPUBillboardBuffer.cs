using UnityEngine;

using VFrame.ABSystem;

//0-------2
//|	    / |
//|	  /   |
//| /	  |
//1-------3

public class GPUBillboardBuffer
{
	const int BC_VERTEX_EACH_BOARD = 4;
	const int BC_INDICES_EACH_BOARD = 6;
	const int BC_TEXTURE_ROW_COLUMN = 4;
	const float BC_FONT_WIDTH = 0.6f;
	
	private static GPUBillboardBuffer instance = null;
	
    public static GPUBillboardBuffer Instance()
    {
        
        {
            if (instance == null)
            {
                instance = new GPUBillboardBuffer(); 
				instance.Init();
            }
            return instance;
        }
    }    

	
	GameObject			mGameObject;
	Mesh				mMesh;
	Material			mMaterial;
	MeshFilter 			mFilter;
	MeshRenderer 		mRenderer;
	
	Vector3[]			mCenters;
	Vector4[]			mPosXYLifeScale;
	Vector2[] 			mUv;
	Color[]				mColors;
	
	Vector2 			mUVIncrease;
	
	uint				mMaxBoardSize = 0;
	uint				mBoardIndex = 0;

	
	public void OnLeaveStage()
	{
		mGameObject=null;
		mMesh=null;
		mMaterial=null;
	 	mFilter=null;
	 	mRenderer=null;
	}
	
	public void Init()
	{
		GPUBillboardBufferInit();
		SetupBillboard( 500 );
        AssetBundleManager.Instance.Load("Assets.Res.Texture.Number.png", (go) => {
            SetTexture(go.mainObject as Texture);
        });
		
	}

	private void GPUBillboardBufferInit()
	{
		mGameObject = new GameObject( "GPUBillboardBuffer" );
		mFilter = mGameObject.AddComponent<MeshFilter>();		
		mRenderer = mGameObject.AddComponent<MeshRenderer>();
#if UNITY_EDITOR
		mRenderer.enabled = true;
#endif
		mMaterial = new Material( Shader.Find( "Billboard/BillboardParticl" ) );
		mRenderer.material = mMaterial;
		
		mMesh = new Mesh();
		mFilter.mesh = mMesh;

	}
	//-------------------------------------------------------------------------------------------//
	public void SetDisappear( float d )
	{
		mMaterial.SetFloat( "_Disappear", d );
	}
	//-------------------------------------------------------------------------------------------//
	public void SetTexture( Texture tex )
	{
		mMaterial.SetTexture( "_MainTex", tex );
	}
	//-------------------------------------------------------------------------------------------//
	public void SetLife(float d)
	{
		mMaterial.SetFloat( "_Life",d);
	}
	//-------------------------------------------------------------------------------------------//
	public void SetSpeed(float d)
	{
		mMaterial.SetFloat( "_Speed",d);
	}
	//-------------------------------------------------------------------------------------------//
	public void SetAcce(float d)
	{
		mMaterial.SetFloat( "_Acce",d*0.5f);
	}
	//-------------------------------------------------------------------------------------------//
	public void SetScaleTime(float d)
	{
		mMaterial.SetFloat( "_B",d*0.5f);
	}
	//-------------------------------------------------------------------------------------------//
	public void SetScaleSize(float d)
	{
		mMaterial.SetFloat( "_C",d);
	}
	//-------------------------------------------------------------------------------------------//
	public void SetupBillboard( uint maxBoardSize )
	{
		//if( 0 == mMaxBoardSize )
		{
			mUVIncrease = new Vector2( 1.0f/BC_TEXTURE_ROW_COLUMN, 1.0f/BC_TEXTURE_ROW_COLUMN );
			mMaxBoardSize = maxBoardSize;
	
			mPosXYLifeScale = new Vector4[ maxBoardSize * BC_VERTEX_EACH_BOARD ];
			mCenters = new Vector3[ maxBoardSize * BC_VERTEX_EACH_BOARD ];

			mUv  = new Vector2[ maxBoardSize * BC_VERTEX_EACH_BOARD ];

			mColors = new Color[ maxBoardSize * BC_VERTEX_EACH_BOARD ];
	
			mMesh.vertices = mCenters;		
			mMesh.tangents = mPosXYLifeScale;
			mMesh.colors = mColors;
			mMesh.uv  = mUv;
		
			{
				int[] Indices = new int[ maxBoardSize * BC_INDICES_EACH_BOARD ];
				for( int i = 0 ; i < maxBoardSize ; ++ i )
				{
					int index = i*BC_INDICES_EACH_BOARD;
					int vertex = i*BC_VERTEX_EACH_BOARD;
					Indices[index  ] = vertex  ;
					Indices[index+1] = vertex+1;
					Indices[index+2] = vertex+2;
					
					Indices[index+3] = vertex+2;
					Indices[index+4] = vertex+1;
					Indices[index+5] = vertex+3;
				}
				mMesh.triangles = Indices;
			}
		}
		mMesh.bounds = new Bounds( new Vector3(0,0,0), new Vector3( 100000, 100000, 100000 ) );
	}
	//-------------------------------------------------------------------------------------------//
	public void DisplayNumber( int num, Vector2 size, Vector3 center, Color clr ,bool haveScale)
	{
		//mGameObject.transform.position = center;
		int temp = num;
		num = num < 0 ? -num : num;
		float time = Time.timeSinceLevelLoad;


		string numString = num.ToString();
		if( temp >= 0 )
		{
			numString = numString.Insert( 0, "+" );
		}
//		else 
//		{
//			numString = numString.Insert( 0, "-" );
//		}
		int numLength = numString.Length;
		Vector2 halfSize = new Vector2( size.x * 0.5f, size.y * 0.5f );
		float leftBio =  - size.x * 0.5f * BC_FONT_WIDTH * numLength;

		int inthaveScale = 1;
		if(!haveScale)
		{
			inthaveScale = 0;
		}

	
		for( int i = 0; i < numLength ; ++ i )
		{
			uint indexPos = mBoardIndex * BC_VERTEX_EACH_BOARD;			
			mPosXYLifeScale[indexPos  ].Set( -halfSize.x+leftBio+i*size.x * BC_FONT_WIDTH ,  halfSize.y, time, inthaveScale  );
			mPosXYLifeScale[indexPos+1].Set( -halfSize.x+leftBio+i*size.x * BC_FONT_WIDTH , -halfSize.y, time, inthaveScale  );
			mPosXYLifeScale[indexPos+2].Set(  halfSize.x+leftBio+i*size.x * BC_FONT_WIDTH ,  halfSize.y, time, inthaveScale  );
			mPosXYLifeScale[indexPos+3].Set(  halfSize.x+leftBio+i*size.x * BC_FONT_WIDTH , -halfSize.y, time, inthaveScale  );
			
			mCenters[indexPos  ] = center;
			mCenters[indexPos+1] = center;
			mCenters[indexPos+2] = center;
			mCenters[indexPos+3] = center;
			
			mColors[indexPos  ] = clr;
			mColors[indexPos+1] = clr;
			mColors[indexPos+2] = clr;
			mColors[indexPos+3] = clr;


			{//计算UV//
				int eachNum = 0;
				switch( numString[i] )
				{
				case '+':
				{
					eachNum = 10;
				}break;
				case '-':
				{
					eachNum = 11;
				}break;
				default:
				{
					eachNum = numString[i] - '0';
				}break;
				}
				int row = eachNum / BC_TEXTURE_ROW_COLUMN;
				int col = eachNum % BC_TEXTURE_ROW_COLUMN;
				Vector2 uvBegin = new Vector2( mUVIncrease.x * col, 1 - mUVIncrease.y * row );				
				mUv[indexPos  ] = uvBegin;
				mUv[indexPos+1].Set( uvBegin.x, uvBegin.y - mUVIncrease.y );
				mUv[indexPos+2].Set( uvBegin.x + mUVIncrease.x, uvBegin.y );
				mUv[indexPos+3].Set( uvBegin.x + mUVIncrease.x, uvBegin.y - mUVIncrease.y );


		
			}
		
			mBoardIndex = ++ mBoardIndex < mMaxBoardSize ? mBoardIndex : 0;
		}
		mMesh.vertices = mCenters;		
		mMesh.tangents = mPosXYLifeScale;
		mMesh.colors = mColors;
		mMesh.uv = mUv;

	}
}

