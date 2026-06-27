varying vec4 normals;
varying vec4 transformed_vertex_position;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
	return vec4(normals.xyz,1.0);
}
