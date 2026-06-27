
uniform Image normals_buffer;
uniform Image ssao_buffer;

varying mat4 projection;
varying vec4 transformed_vertex_position;

vec3 light_direction = vec3(0.0,0.0,-1.0);
vec3 view_position = vec3(0.0,0.0,0.0);
float specular_strength = 0.128;

vec2 texel_size = 1/vec2(love_ScreenSize.xy);

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
	vec3 normal = Texel(normals_buffer, screen_coords*texel_size).rbg;
	float occlusion = Texel(ssao_buffer, screen_coords*texel_size).r;

	vec3 view_direction = normalize(view_position - transformed_vertex_position.xyz);
	vec3 reflection_direction = reflect(-light_direction, normal);
	float specular_amount = pow(max(dot(view_direction, reflection_direction), 0.0), 4);
	vec3 specular = specular_strength * specular_amount*color.xyz;

	vec3 ambient = color.xyz*0.3;
	float diffuse = 0.9+0.1*max(dot(normal, light_direction),0.0);
	
	return vec4(color.xyz*(diffuse+ambient+specular)*occlusion,color.a);
}
