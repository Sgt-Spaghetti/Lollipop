uniform mat4 translation;
uniform mat4 rotation;
uniform mat4 perspective;

attribute vec4 VertexNormals;

varying vec4 normals;
varying vec4 transformed_vertex_position;
varying mat4 projection;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	projection = perspective;
	normals = VertexNormals;
	transformed_vertex_position = translation * rotation * vertex_position;
	return perspective * transformed_vertex_position;
}
