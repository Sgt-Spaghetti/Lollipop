uniform Image normals_buffer;
uniform Image ssao_buffer;

uniform Image transformed_vertex_position;

vec3 light_direction = vec3(0.0,0.0,-1.0);
vec3 view_position = vec3(0.0,0.0,0.0);
float specular_strength = 0.128;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
	vec3 base_colour = Texel(tex, texture_coords).rgb;
	vec3 normal = Texel(normals_buffer, texture_coords).rbg;
	float occlusion = Texel(ssao_buffer, texture_coords).r;

	vec3 current_position = Texel(transformed_vertex_position, texture_coords).xyz;
	vec3 view_direction = normalize(view_position - current_position);
	vec3 reflection_direction = reflect(-light_direction, normal);
	float specular_amount = pow(max(dot(view_direction, reflection_direction), 0.0), 4);
	vec3 specular = specular_strength * specular_amount*color.xyz;

	vec3 ambient = 0.3*base_colour;
	float diffuse = 0.9+0.1*max(dot(normal, light_direction),0.0);
	
	return vec4(occlusion*base_colour*(diffuse+ambient+specular),1.0);
}
