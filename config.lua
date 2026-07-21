Options{

input_file = "example.pdb",
image_path = "lollipop.png",

rotation_speed = 1,
translation_speed = 1,

low_poly_mesh = "icosphere_s2-smooth.obj",
high_poly_mesh = "icosphere_s3-smooth.obj",
winding_order = "cw",

fov = 150,

ssao_samples = 32, -- Maximum of 128

colour_series = {
			{
			C = {r = 1.00, g = 0.550, b = 0.550, a = 1},
			X = {r = 1.00, g = 0.640, b = 0.640, a = 1},
			},
			{
			C = {r = 0.700, g = 0.700, b = 1.00, a = 1},
			X = {r = 0.640, g = 0.640, b = 1.00, a = 1},
			},
		},

saved_rotation = {},
saved_translation = {},
}

