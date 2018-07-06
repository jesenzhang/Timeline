#ifndef WEATHER__CGINC 
 
inline float3 PerPixelNormal(sampler2D bumpMap, float4 coords, float3 vertexNormal, float bumpStrength) 
{ 
	float4 bump = tex2D(bumpMap, coords.xy) + tex2D(bumpMap, coords.zw);
	bump.xy = bump.wy - float2(1.0, 1.0); 
	float3 worldNormal = vertexNormal + bump.xxy * bumpStrength * float3(1,0,1);
	return normalize(worldNormal);
}

bool isInBox(float4 box,float2 pt){
	return pt.x >= box.x && pt.y >= box.y && pt.x <= box.z && pt.y <= box.w;
}

float nearestDistance(float4 box,float2 pt){
	float nearestX = min(pt.x - box.x,pt.y - box.y);
	float nearestY = min(box.z - pt.x,box.w - box.y); 
	return min(nearestX,nearestY);
}


#ifndef _RAIN_ENABLE
#define _RAIN_ENABLE
#endif
 
  
float _WeatherTextureScale;
 
sampler2D _SnowTexture;

float _SnowPower;
float _SnowMultiplier;
float _SnowStartHeight;

  
sampler2D _RainBump; 

fixed4 _RainSpecularColor;
float _Distort;
float _RainMultiplier;  
float _RainShininess;

float _Bolting;
float _BoltMulitplier;  

float4 _WeatherRange;
float _WeatherAmount;
float _Temperature;

float _Weather0;
float _Weather1; 

//float4 _Weathers[4]; 
//float4 _WeatherRanges[4];

float4 _Weathers0; 
float4 _WeatherRanges0;

float4 _Weathers1; 
float4 _WeatherRanges1;

float4 _Weathers2; 
float4 _WeatherRanges2;

float4 _Weathers3; 
float4 _WeatherRanges3;

struct WeatherInput 
{  
	float2 mainCoords;
	float3 worldNormal; 
	float3 localNormal;
	float3 worldPos;
	float3 viewDir;
	float4 bumpCoords;
}; 

inline fixed getNoiseFactor(fixed3 col){
	return 1 - (col.r+col.g+col.b)/3;
}

bool getWeatherInfo(float index,float3 worldPos,inout float4 result){
	//if( index > 0 && isInBox(_WeatherRanges[index - 1],worldPos.xz)){
	//	result = _Weathers[index-1];
	//	return true;
	//}
	if(index == 1 && isInBox(_WeatherRanges0,worldPos.xz)){
		result = _Weathers0;
		return true;
	} else if(index == 2 && isInBox(_WeatherRanges1,worldPos.xz)){
		result = _Weathers1;
		return true;
	} else if(index == 3 && isInBox(_WeatherRanges2,worldPos.xz)){
		result = _Weathers2;
		return true;
	} else if(index == 4 && isInBox(_WeatherRanges3,worldPos.xz)){
		result = _Weathers3;
		return true;
	}
	return false;
}

float getWeatherAmount(float3 worldPos){
	float4 weatherInfo = float4(0,0,0,0);
	if(getWeatherInfo(_Weather0,worldPos,weatherInfo)){
		return weatherInfo.x; 
	}
	if(getWeatherInfo(_Weather1,worldPos,weatherInfo)){
		return weatherInfo.x; 
	} 
	return _WeatherAmount; 
}
 

inline float getSnowAmount(float3 worldPos){
	return getWeatherAmount(worldPos);
}

inline float getRainAmount(float3 worldPos){ 
	return getWeatherAmount(worldPos);
}

float getTemperature(float3 worldPos){ 
	float4 weatherInfo = float4(0,0,0,0);
	if(getWeatherInfo(_Weather0,worldPos,weatherInfo)){
		return weatherInfo.y; 
	}
	if(getWeatherInfo(_Weather1,worldPos,weatherInfo)){
		return weatherInfo.y; 
	}  
	return _Temperature;
}

inline float getWeatherBlendAmount(float index,float3 worldPos){
	//if(index > 0){ 
	//	float4 box = _WeatherRanges[index - 1];
	//	if(isInBox(box,worldPos.xz)){ 
	//		return _Weathers[index - 1].x * ( min(1,nearestDistance(box,worldPos.xz)/2));
	//	}
	//}
	if(index == 1 && isInBox(_WeatherRanges0,worldPos.xz)){
		return _Weathers0.x * ( min(1,nearestDistance(_WeatherRanges0,worldPos.xz)/2));
	} else if(index == 2 && isInBox(_WeatherRanges1,worldPos.xz)){
		return _Weathers1.x * ( min(1,nearestDistance(_WeatherRanges1,worldPos.xz)/2));
	} else if(index == 3 && isInBox(_WeatherRanges2,worldPos.xz)){
		return _Weathers2.x * ( min(1,nearestDistance(_WeatherRanges2,worldPos.xz)/2));
	} else if(index == 4 && isInBox(_WeatherRanges3,worldPos.xz)){
		return _Weathers3.x * ( min(1,nearestDistance(_WeatherRanges3,worldPos.xz)/2));
	}
	return 0;
}

float getWeatherBlends(float3 worldPos){
	float amount = 0;
	amount = max(amount,getWeatherBlendAmount(_Weather0,worldPos));
	amount = max(amount,getWeatherBlendAmount(_Weather1,worldPos)); 

	if(amount==0){
		amount = _WeatherAmount;
	}
	return amount;
}

inline float getRainBlends(float3 worldPos){ 
	return min(0.5,getWeatherBlends(worldPos));
}


inline float getSnowBlends(float3 worldPos){
	return min(0.9,getWeatherBlends(worldPos)); 
}

inline fixed3 applySnowColor(WeatherInput i,fixed3 col){ 
	float _SnowAmount = i.bumpCoords.x;
	if(_SnowAmount<=0)
		return col;
	fixed4 snow = tex2D(_SnowTexture, i.mainCoords * _WeatherTextureScale); 
	float snowAmount = _SnowAmount * _SnowMultiplier;
	snowAmount = snowAmount * clamp(i.worldNormal.y+0.1,0,1) * getNoiseFactor(col) * 0.8 + clamp(i.localNormal.y,0,1) * snowAmount * 0.25;
	snowAmount = snowAmount * clamp((i.worldPos.y - _SnowStartHeight)*0.0125,0,1); 
	snowAmount = clamp(pow(snowAmount,_SnowPower)*256,0,1); 
	return col.rgb * (1-snowAmount) + snow.rgb*snowAmount; 
}

inline fixed3 applySnowDiffuseColor(WeatherInput i,fixed3 col){
	float _SnowAmount = i.bumpCoords.x;
	if(_SnowAmount<=0)
		return col;

	fixed4 snow = tex2D(_SnowTexture, i.mainCoords * _WeatherTextureScale); 
	float snowAmount = _SnowAmount * _SnowMultiplier;
	snowAmount = snowAmount * clamp(i.worldNormal.y+0.1,0,1) * getNoiseFactor(col);
	//snowAmount = snowAmount * clamp((i.worldPos.y - _SnowStartHeight)*0.0125,0,1); 
	snowAmount = clamp(pow(snowAmount,_SnowPower)*256,0,1); 
	return col.rgb * (1-snowAmount) + snow.rgb*snowAmount; 
}

inline fixed3 applySnowTerrainColor(WeatherInput i,fixed3 col){
	float _SnowAmount = i.bumpCoords.x;
	if(_SnowAmount<=0)
		return col;

	fixed4 snow = tex2D(_SnowTexture, i.mainCoords * _WeatherTextureScale ); 
	float snowAmount = _SnowAmount * _SnowMultiplier;
	snowAmount = snowAmount * clamp(i.worldNormal.y+0.9,0,1) * (1-col.b); 
	snowAmount = clamp(pow(snowAmount,_SnowPower)*256,0,1);  

	return col.rgb * (1-snowAmount) + snow.rgb*snowAmount; 
} 

#ifdef _RAIN_ENABLE 

inline fixed3 getSpecColor(WeatherInput i){

	// colors in use 
	fixed4 specularColor = _RainSpecularColor * _RainMultiplier;  
	float3 _WorldLightDir = normalize(float3(-1,-2,0));   

	float3 worldNormal = PerPixelNormal(_RainBump, i.bumpCoords, i.worldNormal , _Distort);  

	float3 viewVector = i.viewDir;
	      
	float3 h = normalize ((_WorldLightDir.xyz) + i.viewDir.xyz);
	float nh = max (0, dot (worldNormal, -h));
	float spec = max(0.0,pow (nh, _RainShininess ));  

	//return worldNormal;

	//return fixed3(spec,spec,spec);

	return spec * specularColor.rgb;  
}

fixed3 applyRainColor(WeatherInput i,fixed3 col){
	float _RainAmount = getRainBlends(i.worldPos);
	if(_RainAmount<=0)
		return col;

	fixed4 _BaseColor = fixed4(0,0,0,0.26); 
	float rainAmount = _RainAmount; 
	fixed3 SpecCol = getSpecColor(i);
	//return SpecCol;
	//return i.worldNormal;
	return col.rgb * (1-rainAmount) + (_BaseColor.rgb + SpecCol) * rainAmount;    
}
 

#endif 

inline fixed3 getBoltColor(fixed3 worldNormal){
	#ifdef _BOLT_ENABLE 
		fixed3 boltColor = float3(_BoltMulitplier,_BoltMulitplier,_BoltMulitplier) * _Bolting * max(0,worldNormal.y);
		return boltColor;
	#else
		fixed3 boltColor = float3(0,0,0);
	#endif
	return boltColor;
}

fixed3 getInfluenceWeathers(WeatherInput input){
	fixed x = _Weather0 == 1?1:0;
	fixed y = _Weather0 == 2?1:0;
	fixed z = _Weather0 == 3?1:0;  
	return fixed3(x,y,z);
	//return fixed3(_Weather0,_Weather1,_Weather2);
}

inline fixed3 applyWeatherColor(WeatherInput input,fixed3 col){ 
	//return getInfluenceWeathers(input);	
	float Temperature = getTemperature(input.worldPos); 
	//return fixed3(Temperature,0,0);
	if(Temperature<=0){
		return applySnowColor(input,col);
	}
	#ifdef _RAIN_ENABLE				
		return applyRainColor(input,col) + getBoltColor(input.worldNormal);
	#endif 
	return col;
}

inline fixed3 applyWeatherDiffuseColor(WeatherInput input,fixed3 col){
	//return getInfluenceWeathers(input);
	float Temperature = getTemperature(input.worldPos); 
	if(Temperature<=0){
		return applySnowDiffuseColor(input,col);
	}
	#ifdef _RAIN_ENABLE		 
		return applyRainColor(input,col) + getBoltColor(input.worldNormal);
	#endif 
	return col;
}

inline fixed3 applyWeatherTerrainColor(WeatherInput input,fixed3 col){
	//return getInfluenceWeathers(input);

	float Temperature = getTemperature(input.worldPos);
	if(Temperature<=0){
		return applySnowTerrainColor(input,col);
	}
	#ifdef _RAIN_ENABLE		 
		return applyRainColor(input,col) + getBoltColor(input.worldNormal);
	#endif
	return col;
} 

inline WeatherInput applyWeatherVertexEffect (inout appdata_full v){  
	WeatherInput o;

	#ifdef _RAIN_ENABLE

	float3 worldSpaceVertex = mul(unity_ObjectToWorld,(v.vertex)).xyz;
	float3 vtxForAni = (worldSpaceVertex).xzz;   

	float4 _BumpTiling = float4(0.08,0.08,0.08,0.08);
	float4 _BumpDirection = float4(5,0,-5,5);
	 
						
	// one can also use worldSpaceVertex.xz here (speed!), albeit it'll end up a little skewed	
	float2 tileableUv = mul(unity_ObjectToWorld,(v.vertex)).xz; 
	tileableUv.xy = v.vertex.xz;
	o.bumpCoords.xyzw = (tileableUv.xyxy + _Time.xxxx * _BumpDirection.xyzw) * _BumpTiling.xyzw; 

	#endif

	return o;
}


#define isWeatherEnabled(input) ((getTemperature(input.worldPos)<=0 && input.bumpCoords.x>0)||(getRainAmount(input.worldPos)>0))

#define APPLY_WEATHER_VERTEX_EFFECT(v,o) \
	float3 worldPos = mul(unity_ObjectToWorld, v.vertex);\
	float Temperature = getTemperature(worldPos);\
	if(Temperature>0){\
		float _RainAmount = getRainAmount(worldPos);\
		if(_RainAmount > 0){\
			WeatherInput temp = applyWeatherVertexEffect(v);\
			o.bumpCoords = temp.bumpCoords;\
		}\
	}else{\
		o.bumpCoords.x = getSnowAmount(worldPos);\
	}

#define INIT_WEATHER_SURFACE_EFFECT(input) \
	WeatherInput _weatherEffectInput;\
	_weatherEffectInput.worldNormal = input.worldNormal;\
	_weatherEffectInput.worldPos = input.worldPos;\
	_weatherEffectInput.bumpCoords = input.bumpCoords;\
	_weatherEffectInput.viewDir = input.viewDir;\

#define APPLY_WEATHER_SURFACE_EFFECT(input,col) \
	INIT_WEATHER_SURFACE_EFFECT(input);\
	_weatherEffectInput.worldNormal = WorldNormalVector(input,o.Normal);\
	_weatherEffectInput.localNormal = UnityWorldToObjectDir(_weatherEffectInput.worldNormal);\
	_weatherEffectInput.mainCoords = input.uv_MainTex;\
	col.rgb = applyWeatherColor(_weatherEffectInput,col.rgb);


#define APPLY_WEATHER_SURFACE_DIFFUSE_EFFECT(input,col) \
	INIT_WEATHER_SURFACE_EFFECT(input);\
	_weatherEffectInput.localNormal = o.Normal;\
	_weatherEffectInput.mainCoords = input.uv_MainTex;\
	col.rgb = applyWeatherDiffuseColor(_weatherEffectInput,col.rgb);


#define APPLY_WEATHER_SURFACE_TERRAIN_EFFECT(input,col) \
	INIT_WEATHER_SURFACE_EFFECT(input);\
	_weatherEffectInput.worldNormal = WorldNormalVector(input,o.Normal);\
	_weatherEffectInput.localNormal = UnityWorldToObjectDir(_weatherEffectInput.worldNormal);\
	_weatherEffectInput.mainCoords = IN.uv_Control;\
	col.rgb = applyWeatherTerrainColor(_weatherEffectInput,col.rgb);  

#endif

#define DECLARE_WEATHER_VERTEX_FUNC(func_name) \
	void func_name(inout appdata_full v,out Input o){\
		UNITY_INITIALIZE_OUTPUT(Input,o);\
		o.uv_MainTex = v.texcoord.xy;\
		APPLY_WEATHER_VERTEX_EFFECT(v,o);\
	}
