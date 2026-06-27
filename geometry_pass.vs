uniform mat4 translation;
uniform mat4 rotation;
uniform mat4 perspective;

attribute vec4 VertexNormals;

varying vec4 normals;
varying vec4 transformed_vertex_position;
varying vec4 perspective_transformed_vertex_position;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	normals = translation*rotation*VertexNormals;
	transformed_vertex_position = translation * rotation * vertex_position;
	perspective_transformed_vertex_position = perspective * transformed_vertex_position;
	return perspective_transformed_vertex_position;
}
