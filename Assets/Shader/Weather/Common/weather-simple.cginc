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


float _WeatherTextureScale;

float _SnowPower;
float _SnowMultiplier;  
sampler2D _SnowTexture;

float _Temperature;
float _WeatherAmount;   

float _Weather0;

//float4 _Weathers[4]; 


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
	float weatherAmount;
	float temperature;
}; 

inline fixed getNoiseFactor(fixed3 col){
	return 1 - (col.r+col.g+col.b)/3;
} 

fixed getWeatherAmount(float3 worldPos){
	//if(_Weather0>0){
	//	return _Weathers[int(_Weather0)-1].x;
	//}
	if(_Weather0 == 1){
		return _Weathers0.x;
	} else if(_Weather0 == 2 ){
		return _Weathers1.x;
	} else if(_Weather0 == 3 ){
		return _Weathers2.x;
	} else if(_Weather0 == 4 ){
		return _Weathers3.x;
	}
	return _WeatherAmount;
}

fixed getTemperature(float3 worldPos){
	//if(_Weather0>0){
	//	return _Weathers[int(_Weather0)-1].y;
	//}
	if(_Weather0 == 1 ){
		return _Weathers0.y;
	} else if(_Weather0 == 2 ){
		return _Weathers1.y;
	} else if(_Weather0 == 3 ){
		return _Weathers2.y;
	} else if(_Weather0 == 4 ){
		return _Weathers3.y;
	}
	return _Temperature;
}

inline fixed3 applySimpleRainColor(WeatherInput i,fixed3 col){
	if(i.weatherAmount<=0)
		return col;		  
	//return fixed3(0,0,1);
	return col.rgb * (1-i.weatherAmount * 0.8);    
}

inline fixed3 applySimpleSnowColor(WeatherInput i,fixed3 col){
	if(i.weatherAmount<=0)
		return col; 
	fixed4 snow = tex2D(_SnowTexture, i.mainCoords * _WeatherTextureScale); 
	float snowAmount = i.weatherAmount * _SnowMultiplier;
	snowAmount = snowAmount * clamp(i.worldNormal.y+0.1,0,1) * getNoiseFactor(col);  
	snowAmount = clamp(pow(snowAmount,_SnowPower * 0.85)*256,0,1);  
	return col.rgb * (1-snowAmount) + snow.rgb*snowAmount; 
}

inline fixed3 applySimpleSnowTerrainColor(WeatherInput i,fixed3 col){	
	if(i.weatherAmount<=0)
		return col;
	fixed4 snow = tex2D(_SnowTexture, i.mainCoords * _WeatherTextureScale); 
	float snowAmount = i.weatherAmount * _SnowMultiplier;
	snowAmount = snowAmount * clamp(i.worldNormal.y+0.2,0,1) * (1-col.b) ; 
	snowAmount = clamp(pow(snowAmount,_SnowPower)*256,0,1);  
	return col.rgb * (1-snowAmount) + snow.rgb*snowAmount; 
}

inline fixed3 applySimpleWeatherColor(WeatherInput input,fixed3 col){	
	if(input.temperature<=0){
		return applySimpleSnowColor(input,col);
	}
	#ifdef _RAIN_ENABLE				
		return applySimpleRainColor(input,col);
	#endif 
	return col;
}

inline fixed3 applySimpleWeatherTerrainColor(WeatherInput input,fixed3 col){
	if(input.temperature<=0){
		return applySimpleSnowTerrainColor(input,col);
	}
	#ifdef _RAIN_ENABLE				
		return applySimpleRainColor(input,col);
	#endif 
	return col;
}
 
 
#define isWeatherEnabled(input) (IN.weatherAmount>0)

#define APPLY_SIMPLE_WEATHER_VERTEX_EFFECT(v,o) \
	float3 worldPos = mul(unity_ObjectToWorld, v.vertex);\
	o.temperature = getTemperature(worldPos);\
	o.weatherAmount = getWeatherAmount(worldPos);

#define APPLY_SIMPLE_WEATHER_SURFACE_EFFECT(input,col) \
	WeatherInput _weatherEffectInput;\
	_weatherEffectInput.worldNormal = input.worldNormal;\
	_weatherEffectInput.mainCoords = input.uv_MainTex;\
	_weatherEffectInput.weatherAmount = input.weatherAmount;\
	_weatherEffectInput.temperature = input.temperature;\
	col.rgb = applySimpleWeatherColor(_weatherEffectInput,col.rgb);

#define APPLY_SIMPLE_WEATHER_SURFACE_NORMAL_EFFECT(input,col) \
	WeatherInput _weatherEffectInput;\
	_weatherEffectInput.worldNormal = WorldNormalVector(input,o.Normal);\
	_weatherEffectInput.mainCoords = input.uv_MainTex;\
	_weatherEffectInput.weatherAmount = input.weatherAmount;\
	_weatherEffectInput.temperature = input.temperature;\
	col.rgb = applySimpleWeatherColor(_weatherEffectInput,col.rgb);


#define APPLY_SIMPLE_WEATHER_SURFACE_TERRAIN_EFFECT(input,col) \
	WeatherInput _weatherEffectInput;\
	_weatherEffectInput.worldNormal = WorldNormalVector(input,o.Normal);\
	_weatherEffectInput.mainCoords = IN.uv_Control;\
	_weatherEffectInput.weatherAmount = input.weatherAmount;\
	_weatherEffectInput.temperature = input.temperature;\
	col.rgb = applySimpleWeatherTerrainColor(_weatherEffectInput,col.rgb);

#endif

#define DECLARE_WEATHER_VERTEX_FUNC(func_name) \
	void func_name(inout appdata_full v,out Input o){\
		UNITY_INITIALIZE_OUTPUT(Input,o);\
		o.uv_MainTex = v.texcoord.xy;\
		APPLY_SIMPLE_WEATHER_VERTEX_EFFECT(v,o);\
	}
