uniform Image depth_buffer;
uniform float near;
uniform float far;

vec2 texelSize = 1.0 / vec2(love_ScreenSize.xy);

vec2 offsets[25] = vec2[25](
			vec2(-2.0,2.0),
			vec2(-1.0,2.0),
			vec2(0.0,2.0),
			vec2(1.0,2.0),
			vec2(2.0,2.0),
			vec2(-2.0,1.0),
			vec2(-1.0,1.0),
			vec2(0.0,1.0),
			vec2(1.0,1.0),
			vec2(2.0,1.0),
			vec2(-2.0,0.0),
			vec2(-1.0,0.0),
			vec2(0.0,0.0),
			vec2(1.0,0.0),
			vec2(2.0,0.0),
			vec2(-2.0,-1.0),
			vec2(-1.0,-1.0),
			vec2(0.0,-1.0),
			vec2(1.0,-1.0),
			vec2(2.0,-1.0),
			vec2(-2.0,-2.0),
			vec2(-1.0,-2.0),
			vec2(0.0,-2.0),
			vec2(1.0,-2.0),
			vec2(2.0,-2.0)
			);

float depth_threshold = 0.02;

float linearise_depth(float depth, float near_clipping, float far_clipping)
{
	return ((2.0*near*far)/(far+near-(depth*2.0-1.0)*(far-near)))/far;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
	
	float current_depth = linearise_depth(Texel(depth_buffer, texture_coords).r, near, far);
	float pixel_count = 0.0;
	for (int i=0;i<25;i++){
		float depth = linearise_depth(Texel(depth_buffer, texture_coords + texelSize*offsets[i]).r, near, far);
		if (current_depth - depth>  depth_threshold){
			pixel_count += 1.0;
		}
	}

	if (current_depth > 0.999 && pixel_count < 3){
		return vec4(0.0,0.0,0.0,0.0);
	}
	else if (pixel_count < 3){
		vec4 image_color = Texel(tex, texture_coords);
		return image_color;
	}
	else{
		return vec4(0.0, 0.0, 0.0, 1.0);
	}
}
