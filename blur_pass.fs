uniform Image ssao;

vec2 kernel[9] = vec2[9](
				vec2(-1,-1),
				vec2(0,-1),
				vec2(1,-1),
				vec2(-1,0),
				vec2(0,0),
				vec2(1,0),
				vec2(-1,1),
				vec2(0,1),
				vec2(1,1)
			);

vec2 texel_size = 1/vec2(love_ScreenSize.xy);


vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
	float average = 0.0;
	for (int i=0; i<9; i++){
		average += Texel(ssao, texture_coords + kernel[i]*texel_size).r;
	}
	average /= 18;
	return vec4(average, average, average, color.a);
	return vec4( average, average, average, color.a);
}
