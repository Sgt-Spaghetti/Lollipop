local obj_loader = require("load_obj")

local vertex_shader = [[

uniform mat4 transform;
uniform mat4 perspective;

attribute vec4 VertexNormals;

varying vec4 normals;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	normals = transform * VertexNormals;	
	return perspective * transform * vertex_position;
}

]]

local pixel_shader = [[
varying vec4 normals;
vec3 light = vec3(0.0,0.0,-1.0);

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
	vec4 texturecolor = Texel(tex, texture_coords);
	float sim = dot(normals.xyz, light);
	return vec4(color.xyz*sim,color.a);
}
]]

local vertex_format = { {"VertexPosition", "float", 3},
    			{"VertexNormals", "float", 4},
    			{"VertexColor", "byte", 4},
		      }

local pdbfile = "9X49.pdb"

local GLOBALVARS = {
			["ZOOM"] = 120,
			["CAMERA"] = {["x"] = 0, ["y"] = 0, ["z"] = 1},
			["LIGANDS"] = {},
			["POINTS"] = {},
			["SHAPES"] = {},
		   }

-- array that holds all the GLOBALVARS["POINTS"]
-- Each point has an x value, y value, z value and atom type

-- Parse the PDB file and store the atomic coordinates in a 'point' construct
local file = io.open(pdbfile, "r")
for line in file:lines() do
		if line:sub(1,4) == "ATOM" then
			local point = {
					tonumber(line:sub(31,38)),
					tonumber(line:sub(39,46)),
					tonumber(line:sub(47,54)),
					["id"] = tonumber(line:sub(7,11)),
					["type"] = line:sub(13,16),
					["aa"] = line:sub(18,20),
					["chain"] = line:sub(22,22),
					["aan"] = tonumber(line:sub(23,26)),
					["e"] = line:sub(78,78)
				       }

			GLOBALVARS["POINTS"][#GLOBALVARS["POINTS"]+1] = point

		elseif line:sub(1,6) == "HETATM" then

			local point = {	
					tonumber(line:sub(31,38)),
					tonumber(line:sub(39,46)),
					tonumber(line:sub(47,54)),
					["id"] = tonumber(line:sub(7,11)),
					["type"] = line:sub(13,16),
					["aa"] = line:sub(18,20),
					["chain"] = line:sub(22,22),
					["aan"] = tonumber(line:sub(23,26)),
					["e"] = line:sub(78,78)
				       }

			GLOBALVARS["LIGANDS"][#GLOBALVARS["LIGANDS"]+1] = point
		end
end

--[[
GLOBALVARS["POINTS"] = {
			{0, 0, 0, ["e"] = "C"},
			--{0.5, 0, 2, ["e"] = "C"},
			--{0, 0, -1, ["e"] = "O"},
			--{2, 2, 4, ["e"] = "C"},
			--{-1, -1, 3, ["e"] = "O"},
			}
--]]

function generate_icosphere(scale)

	icosphere = obj_loader.load_OBJ("icosphere_s2-smooth.obj", scale)	

	return icosphere

end

function instance_icosphere(object, origin, colour)

	local icosphere = obj_loader.instance(object)

	translate_3D(icosphere["TRIANGLES"], origin[1], origin[2], origin[3])

	for i=1, #icosphere["TRIANGLES"] do
		icosphere["TRIANGLES"][i][8] = colour.r
		icosphere["TRIANGLES"][i][9] = colour.g
		icosphere["TRIANGLES"][i][10] = colour.b
		icosphere["TRIANGLES"][i][11] = colour.a
	end

	icosphere["MESH"] =  love.graphics.newMesh(vertex_format, icosphere["TRIANGLES"], "triangles")
	return icosphere
end



-- Project a 3D point to a 2D plane
-- Assumes the projection plane lies at the world origin
-- The camera faces in the positive Z direction from (0,0,0)
function project_2D(triangles, zoom, dpi, width, height)
	local half_height = height/2
	local half_width = width/2
	for i=1, #triangles do
		local triangle = triangles[i]
			 
		triangle[1] = half_width + (dpi * (triangle[1] / (triangle[3]+zoom)))
		triangle[2] = height - ((dpi * (triangle[2] / (triangle[3]+zoom))) + half_height)

		triangle[4] = half_width + (dpi * (triangle[4] / (triangle[6]+zoom)))
		triangle[5] = height - ((dpi * (triangle[5] / (triangle[6]+zoom))) + half_height)

		triangle[7] = half_width + (dpi * (triangle[7] / (triangle[9]+zoom)))
		triangle[8] = height - ((dpi * (triangle[8] / (triangle[9]+zoom))) + half_height)
	end
end

function love.load()
	--[[
	love.profiler = require("profile")
	love.profiler.start()
	--]]
	love.graphics.setPointSize(10)
	local width, height = love.graphics.getDimensions()
	GLOBALVARS["SCREEN"] = {["x"] = width, ["y"] = height} 

	-- Center the loaded PDB file to the world origin
	-- Take the origin of the PDB molecule as the mean
	-- of all its coordinates
	function mean(list)
		local total = 0
		for i=1, #list do
			total = total + list[i]
		end
		return total / #list
	end

	local xs = {}
	local ys = {}
	local zs = {}
	for i=1, #GLOBALVARS["POINTS"] do
		local p = GLOBALVARS["POINTS"][i]
		xs[#xs+1] = p[1]
		ys[#ys+1] = p[2]
		zs[#zs+1] = p[3]
	end

	-- Translate the PDB from its center to world origin
	translate_3D(GLOBALVARS["POINTS"], -1*mean(xs), -1*mean(ys), -1*mean(zs))

	local icosphere = generate_icosphere(1.5)

	local shapes = {}
	for i=1, #GLOBALVARS["POINTS"] do
		if GLOBALVARS["POINTS"][i].e == "C" then
			local colour = {["r"]=1,
					["g"]=0.41,
					["b"]=0.38,
					["a"] = 1}
			shapes[#shapes+1] = instance_icosphere(icosphere, GLOBALVARS["POINTS"][i], colour)
		else
			local colour = {["r"]=1,
					["g"]=0.32,
					["b"]=0.28,
					["a"] = 1,}
			shapes[#shapes+1] = instance_icosphere(icosphere, GLOBALVARS["POINTS"][i], colour)
		end
	end
	GLOBALVARS["SHAPES"] = shapes

end

local shader = love.graphics.newShader(pixel_shader, vertex_shader)

function model_transform (translation, scale, rotation)
	local cos = math.cos
	local sin = math.sin
	local c3 = cos(rotation[3])
	local s3 = sin(rotation[3])
	local c2 = cos(rotation[1])
	local s2 = sin(rotation[1])
	local c1 = cos(rotation[2])
	local s1 = sin(rotation[2])
	local sx = 1 or scale[1]
	local sy = sx or scale[2]
	local sz = sx or scale[3]
	local tx = translation[1]
	local ty = translation[2]
	local tz = translation[3]

	return { {(sx*s1*s2*s3) + (sx*c1*c3), (sy*c3*s1*s2) - (sy*c1*s3), (sz*c2*s1), tx},
		 {(sx*c2*s3), (sy*c2*c3), (-1*(sz*s2)), ty},
		 {(sx*c1*s2*s3)-(sx*s1*c3), (sy*c1*c3*s2)+(sy*s1*s3), (sz*c1*c2), tz},
		  {0,0,0,1}
		}

end
function model_rotation(rotation)
	local cos = math.cos
	local sin = math.sin
	local c3 = cos(rotation[3])
	local s3 = sin(rotation[3])
	local c2 = cos(rotation[1])
	local s2 = sin(rotation[1])
	local c1 = cos(rotation[2])
	local s1 = sin(rotation[2])

	return { {(s1*s2*s3) + (c1*c3), (c3*s1*s2) - (c1*s3), (c2*s1)},
		 {(c2*s3), (c2*c3), (-1*(s2))},
		 {(c1*s2*s3)-(s1*c3), (c1*c3*s2)+(s1*s3), (c1*c2)},
		  {0,0,0,1}
		}
end




function perspective_matrix(fov, aspect, near, far)
	local tan = math.tan
	local f = tan((fov/2) * (180/math.pi))
	local top = tan(fov/2)*near
	local bottom = -top
	local right = top*aspect
	local left = -top*aspect
 
	return {	{ (2*near)/(right-left),                     0, (right+left)/(right-left),                        0},
			{                     0, (2*near)/(top-bottom), (top+bottom)/(top-bottom),                        0},
			{                     0,                     0,            far/(far-near), (-1*far*near)/(far-near)},
			{                     0,                     0,                         1,                        0}		
		}
end

local perspective = perspective_matrix(90, 1920/1080, 0.01, 1000)

function love.resize(w,h)
	local width, height = love.graphics.getDimensions()
	GLOBALVARS["SCREEN"] = {["x"] = width, ["y"] = height} 
end

love.frame=0
local time = 0
function love.update(dt)
	time = time + dt
	--[[
	if love.frame%100 == 0 then	
		love.report = love.profiler.report(20)
		print(love.report)
		love.profiler.reset()
	end
	love.frame = love.frame + 1
	--]]
end

function love.draw()

--		print("Current FPS: "..tostring(love.timer.getFPS()))
		
		local transform = model_transform({0,0,100},
						  1,
						  {time/2,time/2,time/2})
		love.graphics.setColor(1,1,1,1)
		love.graphics.setShader(shader)
		shader:send("perspective", perspective)
		shader:send("transform", transform)

		love.graphics.setDepthMode("lequal", true)

		for i=1, #GLOBALVARS["SHAPES"] do
			love.graphics.draw(GLOBALVARS["SHAPES"][i]["MESH"])
		end

end

function translate_3D(data, distance_x, distance_y, distance_z)
		for i=1, #data do
			data[i][1] = data[i][1] + distance_x
			data[i][2] = data[i][2] + distance_y
			data[i][3] = data[i][3] + distance_z
		end
end

function rotate_3D(data, theta_x, theta_y, theta_z)
	
	local sin = math.sin
	local cos = math.cos

	for i=1, #data do
		local output_rx_x = data[i].x
		local output_rx_y = cos(theta_x) * data[i].y - sin(theta_x) * data[i].z
		local output_rx_z = sin(theta_x) * data[i].y + cos(theta_x) * data[i].z

		local output_ry_x = cos(theta_y) * output_rx_x + sin(theta_y) * output_rx_z
		local output_ry_y = output_rx_y 
		local output_ry_z = cos(theta_y) * output_rx_z - sin(theta_y) * output_rx_x

		data[i].x = cos(theta_z) * output_ry_x - sin(theta_z) * output_ry_y
		data[i].y = sin(theta_z) * output_ry_x + cos(theta_z) * output_ry_y
		data[i].z = output_ry_z
	end
end

-- Assumes clockwise winding order
function normal(vert3D_1, vert3D_2, vert3D_3)
	local sqrt = math.sqrt
	local vector_v1v2 = {vert3D_2.x-vert3D_1.x, vert3D_2.y-vert3D_1.y, vert3D_2.z-vert3D_1.z}
	local vector_v1v3 = {vert3D_3.x-vert3D_1.x, vert3D_3.y-vert3D_1.y, vert3D_3.z-vert3D_1.z}

	local cross_product = {
				["x"] = vector_v1v2[2]*vector_v1v3[3] - vector_v1v2[3]*vector_v1v3[2],
				["y"] = vector_v1v2[3]*vector_v1v3[1] - vector_v1v2[1]*vector_v1v3[3],
				["z"] = vector_v1v2[1]*vector_v1v3[2] - vector_v1v2[2]*vector_v1v3[1]
				}

	local magnitude = sqrt(cross_product.x^2 + cross_product.y^2 + cross_product.z^2)
	cross_product.x = cross_product.x / magnitude
	cross_product.y = cross_product.y / magnitude
	cross_product.z = cross_product.z / magnitude
	return cross_product
end

function mag(vec3D)
	local sqrt = math.sqrt
	return sqrt(vec3D.x^2 + vec3D.y^2 + vec3D.z^2)
end

function normalise(vec3D)
	local magnitude = mag(vec3D)
	return { ["x"] = vec3D.x/magnitude, ["y"] = vec3D.y/magnitude, ["z"] =  vec3D.z/magnitude}
end

function cross(vec3D_1, vec3D_2)
	return {
		["x"] = vec3D_1.y*vec3D_2.z - vec3D_1.z*vec3D_2.y,
		["y"] = vec3D_1.z*vec3D_2.x - vec3D_1.x*vec3D_2.z,
		["z"] = vec3D_1.x*vec3D_2.y - vec3D_1.y*vec3D_2.x,
		}
end

function dot(vec3D_1, vec3D_2)
	return vec3D_1.x*vec3D_2.x + vec3D_1.y*vec3D_2.y + vec3D_1.z*vec3D_2.z
end	

