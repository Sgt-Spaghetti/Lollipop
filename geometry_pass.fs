varying vec4 normals;
varying vec4 transformed_vertex_position;
varying vec4 projected_transformed_vertex_position;

void effect()
{
	love_Canvases[0] = transformed_vertex_position; // transformed vertex coords
	love_Canvases[1] = projected_transformed_vertex_position; // projected transformed vertex coords
	love_Canvases[2] = VaryingColor; // block colours
	love_Canvases[3] = vec4(normals.xyz,1.0); // normals colours
}
