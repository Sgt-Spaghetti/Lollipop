local obj_loader = require("load_obj")


local vertex_format = { {"VertexPosition", "float", 3},
    			{"VertexNormals", "float", 4},
    			{"VertexColor", "byte", 4},
		      }


function multiply_mat4(mat4_one, mat4_two)
	return {
			{
			mat4_one[1][1]*mat4_two[1][1] + mat4_one[1][2]*mat4_two[2][1]+mat4_one[1][3]*mat4_two[3][1]+mat4_one[1][4]*mat4_two[4][1],
			mat4_one[1][1]*mat4_two[1][2] + mat4_one[1][2]*mat4_two[2][2]+mat4_one[1][3]*mat4_two[3][2]+mat4_one[1][4]*mat4_two[4][2],
			mat4_one[1][1]*mat4_two[1][3] + mat4_one[1][2]*mat4_two[2][3]+mat4_one[1][3]*mat4_two[3][3]+mat4_one[1][4]*mat4_two[4][3],
			mat4_one[1][1]*mat4_two[1][4] + mat4_one[1][2]*mat4_two[2][4]+mat4_one[1][3]*mat4_two[3][4]+mat4_one[1][4]*mat4_two[4][4],
			},	
			{
			mat4_one[2][1]*mat4_two[1][1] + mat4_one[2][2]*mat4_two[2][1]+mat4_one[2][3]*mat4_two[3][1]+mat4_one[2][4]*mat4_two[4][1],
			mat4_one[2][1]*mat4_two[1][2] + mat4_one[2][2]*mat4_two[2][2]+mat4_one[2][3]*mat4_two[3][2]+mat4_one[2][4]*mat4_two[4][2],
			mat4_one[2][1]*mat4_two[1][3] + mat4_one[2][2]*mat4_two[2][3]+mat4_one[2][3]*mat4_two[3][3]+mat4_one[2][4]*mat4_two[4][3],
			mat4_one[2][1]*mat4_two[1][4] + mat4_one[2][2]*mat4_two[2][4]+mat4_one[2][3]*mat4_two[3][4]+mat4_one[2][4]*mat4_two[4][4],
			},	
			{
			mat4_one[3][1]*mat4_two[1][1] + mat4_one[3][2]*mat4_two[2][1]+mat4_one[3][3]*mat4_two[3][1]+mat4_one[3][4]*mat4_two[4][1],
			mat4_one[3][1]*mat4_two[1][2] + mat4_one[3][2]*mat4_two[2][2]+mat4_one[3][3]*mat4_two[3][2]+mat4_one[3][4]*mat4_two[4][2],
			mat4_one[3][1]*mat4_two[1][3] + mat4_one[3][2]*mat4_two[2][3]+mat4_one[3][3]*mat4_two[3][3]+mat4_one[3][4]*mat4_two[4][3],
			mat4_one[3][1]*mat4_two[1][4] + mat4_one[3][2]*mat4_two[2][4]+mat4_one[3][3]*mat4_two[3][4]+mat4_one[3][4]*mat4_two[4][4],
			},	
			{
			mat4_one[4][1]*mat4_two[1][1] + mat4_one[4][2]*mat4_two[2][1]+mat4_one[4][3]*mat4_two[3][1]+mat4_one[4][4]*mat4_two[4][1],
			mat4_one[4][1]*mat4_two[1][2] + mat4_one[4][2]*mat4_two[2][2]+mat4_one[4][3]*mat4_two[3][2]+mat4_one[4][4]*mat4_two[4][2],
			mat4_one[4][1]*mat4_two[1][3] + mat4_one[4][2]*mat4_two[2][3]+mat4_one[4][3]*mat4_two[3][3]+mat4_one[4][4]*mat4_two[4][3],
			mat4_one[4][1]*mat4_two[1][4] + mat4_one[4][2]*mat4_two[2][4]+mat4_one[4][3]*mat4_two[3][4]+mat4_one[4][4]*mat4_two[4][4],
			}	
		}
end

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

	return { {(sx*s1*s2*s3)+(sx*c1*c3), (sy*c3*s1*s2)-(sy*c1*s3),   (sz*c2*s1), tx},
		 {              (sx*c2*s3),               (sy*c2*c3), (-1*(sz*s2)), ty},
		 {(sx*c1*s2*s3)-(sx*s1*c3), (sy*c1*c3*s2)+(sy*s1*s3),   (sz*c1*c2), tz},
		 {                       0,                        0,            0,  1}
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



local GLOBALVARS = {	
			["input_file"] = "example.pdb",
			["ROTATION"] = {},
			["TRANSLATION"] = {},
			["CAMERA"] = {["x"] = 0, ["y"] = 0, ["z"] = 1},
			["LIGANDS"] = {},
			["POINTS"] = {},
			["SHAPES"] = {},
			["colour_series"] = {},
			["PERSPECTIVE"] = perspective_matrix(150, 1920/1080, 20, 200),
			["NEAR_CLIPPING"] = 10,
			["FAR_CLIPPING"] = 200,
		   }

function Options(o)
	for key,value in pairs(o) do
		GLOBALVARS[key] = value
	end
end
dofile("config.lua")

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


function love.resize(w,h)
	local width, height = love.graphics.getDimensions()
	GLOBALVARS["SCREEN"] = {["x"] = width, ["y"] = height} 

	geometry_vertex_positions_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(),love.graphics.getPixelHeight(), {["format"]="rgba16f",["type"]="2d",["readable"] = true})
	geometry_perspective_vertex_positions_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(),love.graphics.getPixelHeight(), {["format"]="rgba16f",["type"]="2d",["readable"] = true})
	geometry_normals_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(),love.graphics.getPixelHeight(), {["format"]="rgba16f",["type"]="2d",["readable"] = true})
	geometry_colours_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(),love.graphics.getPixelHeight(), {["format"]="rgba16f",["type"]="2d",["readable"] = true})
	geometry_depth_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(),love.graphics.getPixelHeight(), {["format"]="depth32f", ["readable"] = true, ["mipmaps"] = "none", ["msaa"] = 0, ["type"]="2d"})

	ssao_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(), love.graphics.getPixelHeight(), {["readable"] = true})
	ssao_blur_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(), love.graphics.getPixelHeight(), {["readable"] = true})
	lighting_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(), love.graphics.getPixelHeight())
	outline_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(), love.graphics.getPixelHeight())
end

function love.keypressed(key, scancode, isrepeat)
	if key == "w" then
		GLOBALVARS["ROTATION"] = multiply_mat4(model_transform({0,0,0},1,{math.pi/180,0,0}),GLOBALVARS["ROTATION"])
	elseif key == "s" then
		GLOBALVARS["ROTATION"] = multiply_mat4(model_transform({0,0,0},1,{-math.pi/180,0,0}),GLOBALVARS["ROTATION"])
	elseif key == "a" then
		GLOBALVARS["ROTATION"] = multiply_mat4(model_transform({0,0,0},1,{0,-math.pi/180,0}),GLOBALVARS["ROTATION"])
	elseif key == "d" then
		GLOBALVARS["ROTATION"] = multiply_mat4(model_transform({0,0,0},1,{0,math.pi/180,0}),GLOBALVARS["ROTATION"])
	elseif key == "q" then
		GLOBALVARS["ROTATION"] = multiply_mat4(model_transform({0,0,0},1,{0,0,-math.pi/180}),GLOBALVARS["ROTATION"])
	elseif key == "e" then
		GLOBALVARS["ROTATION"] = multiply_mat4(model_transform({0,0,0},1,{0,0,math.pi/180}),GLOBALVARS["ROTATION"])
	elseif key == "i" then
		GLOBALVARS["TRANSLATION"] = multiply_mat4(model_transform({0,0,1},1,{0,0,0}),GLOBALVARS["TRANSLATION"])
		local clip_near = GLOBALVARS["NEAR_CLIPPING"] + 1
		local clip_far = GLOBALVARS["FAR_CLIPPING"] + 1
		-- TODO : check if the models.z component is past the near clipping plane. Only then move the near clipping plane outwards.
		GLOBALVARS["NEAR_CLIPPING"] = GLOBALVARS["NEAR_CLIPPING"] + 1
		GLOBALVARS["FAR_CLIPPING"] = clip_far
		GLOBALVARS["PERSPECTIVE"] = perspective_matrix(150, GLOBALVARS["SCREEN"].x/GLOBALVARS["SCREEN"].y, GLOBALVARS["NEAR_CLIPPING"], GLOBALVARS["FAR_CLIPPING"])
	elseif key == "k" then
		GLOBALVARS["TRANSLATION"] = multiply_mat4(model_transform({0,0,-1},1,{0,0,0}),GLOBALVARS["TRANSLATION"])
		local clip_near = GLOBALVARS["NEAR_CLIPPING"] - 1
		local clip_far = GLOBALVARS["FAR_CLIPPING"] - 1
		if clip_near > 0.01 then
			GLOBALVARS["NEAR_CLIPPING"] = clip_near
		elseif clip_far > 0.02 then
			GLOBALVARS["FAR_CLIPPING"] = clip_far
		end
		GLOBALVARS["PERSPECTIVE"] = perspective_matrix(150, GLOBALVARS["SCREEN"].x/GLOBALVARS["SCREEN"].y, GLOBALVARS["NEAR_CLIPPING"], GLOBALVARS["FAR_CLIPPING"])
	elseif key == "j" then
		GLOBALVARS["TRANSLATION"] = multiply_mat4(model_transform({1,0,0},1,{0,0,0}),GLOBALVARS["TRANSLATION"])
	elseif key == "l" then
		GLOBALVARS["TRANSLATION"] = multiply_mat4(model_transform({-1,0,0},1,{0,0,0}),GLOBALVARS["TRANSLATION"])
	elseif key == "u" then
		GLOBALVARS["TRANSLATION"] = multiply_mat4(model_transform({0,-1,0},1,{0,0,0}),GLOBALVARS["TRANSLATION"])
	elseif key == "o" then
		GLOBALVARS["TRANSLATION"] = multiply_mat4(model_transform({0,1,0},1,{0,0,0}),GLOBALVARS["TRANSLATION"])
	elseif key == "escape" then
		love.event.quit()
	end
end


function love.load()


	-- array that holds all the GLOBALVARS["POINTS"]
	-- Each point has an x value, y value, z value and atom type

	-- Parse the PDB file and store the atomic coordinates in a 'point' construct
	local file = io.open(GLOBALVARS["input_file"], "r")
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

	love.keyboard.setKeyRepeat(true)

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

	function max(list)
		local max = list[1]
		for i=1, #list do
			if list[i] > max then
				max = list[i]
			end
		end
		return max
	end

	function min(list)
		local min = list[1]
		for i=1, #list do
			if list[i] < min then
				min = list[i]
			end
		end
		return min
	end

	local xs = {}
	local ys = {}
	local zs = {}
	local chains = {}
	local chain_colours = {}
	for i=1, #GLOBALVARS["POINTS"] do
		local p = GLOBALVARS["POINTS"][i]
		xs[#xs+1] = p[1]
		ys[#ys+1] = p[2]
		zs[#zs+1] = p[3]
		chains[p.chain] = true
	end

	local colour_counter = 0
	for k,v in pairs(chains) do
		chain_colours[k] = (colour_counter%#GLOBALVARS["colour_series"])+1
		colour_counter = colour_counter + 1
	end

	local max_dimensions = {max(xs)-min(xs), max(ys)-min(ys), max(zs)-min(zs)}

	-- Translate the PDB from its center to world origin
	translate_3D(GLOBALVARS["POINTS"], -1*mean(xs), -1*mean(ys), -1*mean(zs))
	translate_3D(GLOBALVARS["LIGANDS"], -1*mean(xs), -1*mean(ys), -1*mean(zs))

	local icosphere = generate_icosphere(1.5)

	local shapes = {}
	for i=1, #GLOBALVARS["POINTS"] do
		local point = GLOBALVARS["POINTS"][i]
		if point.e == "C" then
			local colour = GLOBALVARS["colour_series"][chain_colours[point.chain]]["C"]
			shapes[#shapes+1] = instance_icosphere(icosphere, GLOBALVARS["POINTS"][i], colour)
		else
			local colour = GLOBALVARS["colour_series"][chain_colours[point.chain]]["X"]
			shapes[#shapes+1] = instance_icosphere(icosphere, GLOBALVARS["POINTS"][i], colour)
		end
	end
	for i=1, #GLOBALVARS["LIGANDS"] do
		if GLOBALVARS["LIGANDS"][i]["aa"] == "HEC" then
				local colour = {["r"]=0.988,
						["g"]=0.761,
						["b"]=0.0,
						["a"] = 1,}
				shapes[#shapes+1] = instance_icosphere(icosphere, GLOBALVARS["LIGANDS"][i], colour)
		end
	end

	GLOBALVARS["SHAPES"] = shapes
	GLOBALVARS["ROTATION"] = model_transform({0,0,0},1,{0,0,0})
	GLOBALVARS["TRANSLATION"] = model_transform({0,0,max(max_dimensions)+1},1,{0,0,0})

	geometry_shader = love.graphics.newShader("geometry_pass.fs", "geometry_pass.vs")
	ssao_shader = love.graphics.newShader("ssao_pass.fs")
	ssao_blur_shader = love.graphics.newShader("blur_pass.fs")
	lighting_shader = love.graphics.newShader("lighting_pass.fs")
	outline_shader = love.graphics.newShader("outline_pass.fs")

	geometry_vertex_positions_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(),love.graphics.getPixelHeight(), {["format"]="rgba16f",["type"]="2d",["readable"] = true})
	geometry_perspective_vertex_positions_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(),love.graphics.getPixelHeight(), {["format"]="rgba16f",["type"]="2d",["readable"] = true})
	geometry_normals_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(),love.graphics.getPixelHeight(), {["format"]="rgba16f",["type"]="2d",["readable"] = true})
	geometry_colours_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(),love.graphics.getPixelHeight(), {["format"]="rgba16f",["type"]="2d",["readable"] = true})
	geometry_depth_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(),love.graphics.getPixelHeight(), {["format"]="depth32f", ["readable"] = true, ["mipmaps"] = "none", ["msaa"] = 0, ["type"]="2d"})
	ssao_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(), love.graphics.getPixelHeight(), {["readable"] = true})
	ssao_blur_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(), love.graphics.getPixelHeight(), {["readable"] = true})
	lighting_canvas = love.graphics.newCanvas(love.graphics.getPixelWidth(), love.graphics.getPixelHeight())


	-- SSAO stuff

	function lerp(a,b,f)
		return  a + f * (b-a)
	end
	function normalise(vec3)
		local magnitude = math.sqrt(vec3[1]^2 + vec3[2]^2 + vec3[3]^2)
		return {vec3[1]/magnitude, vec3[2]/magnitude, vec3[3]/magnitude}
	end

	local random = math.random
	local kernel_samples = GLOBALVARS["ssao_samples"]
	sample_kernel = {}
	for i=1, kernel_samples do
		local scale = (i-1)/kernel_samples
		scale = lerp (0.1,1,scale*scale)

		local sample = { (random()*2-1)*scale,
				(random()*2)*scale,
				-random()*scale
				}
		sample_kernel[#sample_kernel+1] = normalise(sample)
	end

	noise_data = love.image.newImageData(4,4,"rgba8", noise_kernel)
	local noise_dimensions = 16 -- 4x4
	for i=0,3 do
		for j=0,3 do
			noise_data:setPixel(j,i,random()*2-1, random()*2-1,0,1)
		end
	end
	noise_texture = love.graphics.newImage(noise_data)
	noise_texture:setWrap("repeat", "repeat")
end

function love.draw()

		-- Geometry Pass: Bake transformed positions, block colours, depth and normals	
		love.graphics.setCanvas({
						{geometry_vertex_positions_canvas},
						{geometry_perspective_vertex_positions_canvas},
						{geometry_colours_canvas},
						{geometry_normals_canvas},
						["depthstencil"] = geometry_depth_canvas,
						["depth"] = true
					})

		love.graphics.setDepthMode("lequal", true)
		love.graphics.clear()

		love.graphics.setFrontFaceWinding("ccw")
		love.graphics.setMeshCullMode("back")
		geometry_shader:send("perspective", GLOBALVARS["PERSPECTIVE"])
		geometry_shader:send("rotation", GLOBALVARS["ROTATION"])
		geometry_shader:send("translation", GLOBALVARS["TRANSLATION"])
		love.graphics.setShader(geometry_shader)


		for i=1, #GLOBALVARS["SHAPES"] do
			love.graphics.draw(GLOBALVARS["SHAPES"][i]["MESH"])
		end

		-- ssao pass

		love.graphics.setCanvas(ssao_canvas)
		love.graphics.clear()
		ssao_shader:send("projection", GLOBALVARS["PERSPECTIVE"])
		ssao_shader:send("normals_buffer", geometry_normals_canvas)
		ssao_shader:send("depth_buffer", geometry_depth_canvas)
		ssao_shader:send("near", GLOBALVARS["NEAR_CLIPPING"])
		ssao_shader:send("far", GLOBALVARS["FAR_CLIPPING"])
		ssao_shader:send("ssao_samples", GLOBALVARS["ssao_samples"])
		ssao_shader:send("sample_kernel", unpack(sample_kernel))
		ssao_shader:send("noise_kernel", noise_texture)
		love.graphics.setShader(ssao_shader)
		love.graphics.draw(geometry_vertex_positions_canvas)

		love.graphics.setCanvas(ssao_blur_canvas)
		love.graphics.clear()
		love.graphics.setShader(ssao_blur)
		love.graphics.draw(ssao_canvas)

		-- lighting pass: add colours

		love.graphics.setCanvas(lighting_canvas)
		love.graphics.clear()
		lighting_shader:send("normals_buffer", geometry_normals_canvas)
		lighting_shader:send("ssao_buffer", ssao_blur_canvas)
		lighting_shader:send("transformed_vertex_position", geometry_vertex_positions_canvas)
		love.graphics.setShader(lighting_shader)
		love.graphics.draw(geometry_colours_canvas)

		-- outline pass
		love.graphics.setCanvas()	
		outline_shader:send("depth_buffer", geometry_depth_canvas)
		outline_shader:send("near", GLOBALVARS["NEAR_CLIPPING"])
		outline_shader:send("far", GLOBALVARS["FAR_CLIPPING"])
		love.graphics.setColor({1.0,1.0,1.0,1.0})
		love.graphics.rectangle("fill", 0,0, GLOBALVARS["SCREEN"].x,GLOBALVARS["SCREEN"].y)
		love.graphics.setShader(outline_shader)
		love.graphics.draw(lighting_canvas)

end

function love.update(dt)
	--print(love.timer.getFPS())
end

function translate_3D(data, distance_x, distance_y, distance_z)
		for i=1, #data do
			data[i][1] = data[i][1] + distance_x
			data[i][2] = data[i][2] + distance_y
			data[i][3] = data[i][3] + distance_z
		end
end

