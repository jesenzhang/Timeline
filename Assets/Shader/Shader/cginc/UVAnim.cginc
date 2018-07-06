#ifndef	_CFSHADER_UVANIM_CGINC_
#define	_CFSHADER_UVANIM_CGINC_

inline float2 uv_translate(float2 uv, float u_speed, float v_speed)
{
	float time = _Time.z;
	float abs_u_speed = abs(u_speed);
	float abs_v_speed = abs(v_speed);
	if(abs_u_speed > 0) uv.x += frac(time * u_speed);
	if(abs_v_speed > 0) uv.y += frac(time * v_speed);
	return uv;
}

inline float2 uv_orient_to(float2 uv, float radians)
{
	const half TWO_PI = 3.14159 * 2;
	const half2 VEC_CENTER = half2(0.5h, 0.5h);

	float abs_radians = abs(radians);
	if(abs_radians > 0)
	{
		uv -= VEC_CENTER;
		half rotation = TWO_PI * frac(radians / 360);
		half sin_rot = sin(rotation);
		half cos_rot = cos(rotation);
		uv = half2(uv.x * cos_rot - uv.y * sin_rot,
				   uv.x * sin_rot + uv.y * cos_rot);
		uv += VEC_CENTER;
	}
	return uv;
}
inline float2 uv_rotate(float2 uv, float speed)
{
	const half TWO_PI = 3.14159 * 2;
	const half2 VEC_CENTER = half2(0.5h, 0.5h);

	float time = _Time.z;
	float absSpeed = abs(speed);
	if(absSpeed > 0)
	{
		uv -= VEC_CENTER;
		half rotation = TWO_PI * frac(time * speed);
		half sin_rot = sin(rotation);
		half cos_rot = cos(rotation);
		uv = half2(uv.x * cos_rot - uv.y * sin_rot,
				   uv.x * sin_rot + uv.y * cos_rot);
		uv += VEC_CENTER;
	}
	return uv;
}

#endif//_CFSHADER_UVANIM_CGINC_