uniform Image normals_buffer;
uniform Image depth_buffer;
uniform float near;
uniform float far;

uniform vec3 sample_kernel[64];
uniform Image noise_kernel;

varying mat4 projection;
varying vec4 transformed_vertex_position;

float radius = 1;

vec2 texel_size = 1/vec2(love_ScreenSize.xy);

float linearise_depth(float depth, float near, float far)
{
	return ((2.0*near*far)/(far+near-(depth*2.0-1.0)*(far-near)))/far;
}


vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
	vec3 normal = Texel(normals_buffer, screen_coords*texel_size).rbg;

	vec2 noise_scale = love_ScreenSize.xy / 4;
	vec3 noise = Texel(noise_kernel, texture_coords*noise_scale).xyz;

	float current_depth = linearise_depth(Texel(depth_buffer, screen_coords/love_ScreenSize.xy).r,near,far);

	vec3 tangent = normalize(noise - normal * dot(noise, normal));
	vec3 bitangent = cross(normal, tangent);
	mat3 TBN = mat3(tangent, bitangent, normal);

	float occlusion = 0.0;
	for (int i=0; i<64; i++){
		vec3 sample_position = TBN * sample_kernel[i];
		sample_position = transformed_vertex_position.xyz + sample_position * radius;
		vec4 offset = projection * vec4(sample_position, 1.0);
		offset.xyz /= offset.w;
		offset.xyz = offset.xyz * 0.5 + 0.5;

		float sample_depth = linearise_depth(Texel(depth_buffer, offset.xy).r, near, far);
		float delta_depth = current_depth - sample_depth;
		float range_check = smoothstep(0.0,1.0,radius / abs(delta_depth));
		if (delta_depth > 0.02){
			occlusion += 1.0*range_check;
		}
	}

	occlusion = 1.0 - (occlusion / 64);

	return vec4(occlusion, occlusion, occlusion,color.a);
}
