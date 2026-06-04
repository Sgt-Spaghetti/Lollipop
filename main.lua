local pdbfile = "example.pdb"

local GLOBALVARS = {
			["DPI"] = 1000, -- "Pixels per PDB unit"
			["ZOOM"] = 35,
			["LIGHT"] = {["x"] = 0, ["y"] = 0, ["z"] = -1},
			["CAMERA"] = {["x"] = 0, ["y"] = 0, ["z"] = 1},
			["POINTS"] = {},
			["LIGANDS"] = {},
			["SHAPES"] = {},
			["ANGLE_ROTATION"] = {["x"] = 0, ["y"] = 0, ["z"] = 0},
			["DISTANCE_TRANSLATION"] = {["x"] = 0, ["y"] = 0, ["z"] = 0},
		   }

-- array that holds all the GLOBALVARS["POINTS"]
-- Each point has an x value, y value, z value and atom type

-- Parse the PDB file and store the atomic coordinates in a 'point' construct
local file = io.open(pdbfile, "r")
for line in file:lines() do
		if line:sub(1,4) == "ATOM" then

			local point = {
					["id"] = tonumber(line:sub(7,11)),
					["type"] = line:sub(13,16),
					["aa"] = line:sub(18,20),
					["chain"] = line:sub(22,22),
					["aan"] = tonumber(line:sub(23,26)),
					["x"] = tonumber(line:sub(31,38)),
					["y"] = tonumber(line:sub(39,46)),
					["z"] = tonumber(line:sub(47,54)),
					["e"] = line:sub(77,78)
				       }

			GLOBALVARS["POINTS"][#GLOBALVARS["POINTS"]+1] = point

		elseif line:sub(1,6) == "HETATM" then

			local point = {
					["id"] = tonumber(line:sub(7,11)),
					["type"] = line:sub(13,16),
					["aa"] = line:sub(18,20),
					["chain"] = line:sub(22,22),
					["aan"] = tonumber(line:sub(23,26)),
					["x"] = tonumber(line:sub(31,38)),
					["y"] = tonumber(line:sub(39,46)),
					["z"] = tonumber(line:sub(47,54)),
					["e"] = line:sub(78,78)
				       }

			GLOBALVARS["LIGANDS"][#GLOBALVARS["LIGANDS"]+1] = point
		end
end

--GLOBALVARS["POINTS"] = {{["x"] = 10, ["y"] = 10, ["z"] = 1}}

function generate_cube(origin, scale)
	local cube = {
			["VERTICES"] = {
					{["x"] = -1*scale, ["y"] = -1*scale, ["z"] = -1*scale},
					{["x"] = -1*scale, ["y"] = 1*scale, ["z"] = -1*scale},
					{["x"] = 1*scale, ["y"] = 1*scale, ["z"] = -1*scale},
					{["x"] = 1*scale, ["y"] = -1*scale, ["z"] = -1*scale},
					{["x"] = -1*scale, ["y"] = -1*scale, ["z"] = 1*scale},
					{["x"] = -1*scale, ["y"] = 1*scale, ["z"] = 1*scale},
					{["x"] = 1*scale, ["y"] = 1*scale, ["z"] = 1*scale},
					{["x"] = 1*scale, ["y"] = -1*scale, ["z"] = 1*scale},
					},
			["FACES"] = {
					{1,2,4},
					{4,2,3},
					{3,2,6},
					{6,7,3},
					{8,7,5},
					{5,7,6},
					{4,8,1},
					{1,8,5},
					{4,3,8},
					{8,3,7},
					{5,6,1},
					{1,6,2},
					}
			}
	cube["VERTICES"] = translate_3D(translate_3D(translate_3D(cube["VERTICES"], origin.x, "x"), origin.y, "y"), origin.z, "z")
	return cube
end

function project_to_unit_sphere(verts)
	local processed = {}
	for i=1, #verts do
		local normal = normal(verts[i])
		processed[#processed+1] = copy_update_point(verts[i], (1/normal.x)*verts[i].x, (1/normal.y)*verts[i].y, (1/normal.z)*verts[i].z)
	end
	return processed
end


function generate_icosahedron(origin, scale, element)

	local phi = (1+math.sqrt(5))*0.5
	local a = 1*scale
	local b = (1*scale)/phi

	local icosahedron = {
				["ELEMENT"] = element,
				["VERTICES"] = {
						{["x"] = 0, ["y"] = b, ["z"] = -a},
						{["x"] = b, ["y"] = a, ["z"] = 0},
						{["x"] = -b, ["y"] = a, ["z"] = 0},
						{["x"] = 0, ["y"] = b, ["z"] = a},
						{["x"] = 0, ["y"] = -b, ["z"] = a},
						{["x"] = -a, ["y"] = 0, ["z"] = b},
						{["x"] = 0, ["y"] = -b, ["z"] = -a},
						{["x"] = a, ["y"] = 0, ["z"] = -b},
						{["x"] = a, ["y"] = 0, ["z"] = b},
						{["x"] = -a, ["y"] = 0, ["z"] = -b},
						{["x"] = b, ["y"] = -a, ["z"] = 0},
						{["x"] = -b, ["y"] = -a, ["z"] = 0},
						},
				["FACES"] = {
						{3,2,1},
						{2,3,4},
						{6,5,4},
						{5,9,4},
						{8,7,1},
						{7,10,1},
						{12,11,5},
						{11,12,7},
						{10,6,3},
						{6,10,12},
						{9,8,2},
						{8,9,11},
						{3,6,4},
						{9,2,4},
						{10,3,1},
						{2,8,1},
						{12,10,7},
						{8,11,7},
						{6,12,5},
						{11,9,5},
					    }
		
				}
	icosahedron["VERTICES"] = translate_3D(translate_3D(translate_3D(icosahedron["VERTICES"], origin.x, "x"), origin.y, "y"), origin.z, "z")
	return icosahedron
end

function generate_icosphere(origin, scale, element, subdivisions)
	local icosphere = {
				["ELEMENT"] = element,
				["VERTICES"] = {
						{ ["x"] = 0.000000*scale, ["y"] = -1.000000*scale, ["z"] = 0.000000*scale},
						{ ["x"] = 0.723607*scale, ["y"] = -0.447220*scale, ["z"] = 0.525725*scale},
						{ ["x"] = -0.276388*scale, ["y"] = -0.447220*scale, ["z"] = 0.850649*scale},
						{ ["x"] = -0.894426*scale, ["y"] = -0.447216*scale, ["z"] = 0.000000*scale},
						{ ["x"] = -0.276388*scale, ["y"] = -0.447220*scale, ["z"] = -0.850649*scale},
						{ ["x"] =  0.723607*scale, ["y"] = -0.447220*scale, ["z"] = -0.525725*scale},
						{ ["x"] = 0.276388*scale, ["y"] = 0.447220*scale, ["z"] = 0.850649*scale},
						{ ["x"] = -0.723607*scale, ["y"] = 0.447220*scale, ["z"] = 0.525725*scale},
						{ ["x"] = -0.723607*scale, ["y"] = 0.447220*scale, ["z"] = -0.525725*scale},
						{ ["x"] =  0.276388*scale, ["y"] = 0.447220*scale, ["z"] = -0.850649*scale},
						{ ["x"] =  0.894426*scale, ["y"] = 0.447216*scale, ["z"] = 0.000000*scale},
						{ ["x"] =  0.000000*scale, ["y"] = 1.000000*scale, ["z"] = 0.000000*scale},
						{ ["x"] =  -0.162456*scale, ["y"] = -0.850654*scale, ["z"] = 0.499995*scale},
						{ ["x"] =  0.425323*scale, ["y"] = -0.850654*scale, ["z"] = 0.309011*scale},
						{ ["x"] =  0.262869*scale, ["y"] = -0.525738*scale, ["z"] = 0.809012*scale},
						{ ["x"] =  0.850648*scale, ["y"] = -0.525736*scale, ["z"] = 0.000000*scale},
						{ ["x"] =  0.425323*scale, ["y"] = -0.850654*scale, ["z"] = -0.309011*scale},
						{ ["x"] =  -0.525730*scale, ["y"] = -0.850652*scale, ["z"] = 0.000000*scale},
						{ ["x"] =  -0.688189*scale, ["y"] = -0.525736*scale, ["z"] = 0.499997*scale},
						{ ["x"] =  -0.162456*scale, ["y"] = -0.850654*scale, ["z"] = -0.499995*scale},
						{ ["x"] =  -0.688189*scale, ["y"] = -0.525736*scale, ["z"] = -0.499997*scale},
						{ ["x"] =  0.262869*scale, ["y"] = -0.525738*scale, ["z"] = -0.809012*scale},
						{ ["x"] =  0.951058*scale, ["y"] = 0.000000*scale, ["z"] = 0.309013*scale},
						{ ["x"] =  0.951058*scale, ["y"] = 0.000000*scale, ["z"] = -0.309013*scale},
						{ ["x"] =  0.000000*scale, ["y"] = 0.000000*scale, ["z"] = 1.000000*scale},
						{ ["x"] =  0.587786*scale, ["y"] = 0.000000*scale, ["z"] = 0.809017*scale},
						{ ["x"] =  -0.951058*scale, ["y"] = 0.000000*scale, ["z"] = 0.309013*scale},
						{ ["x"] =  -0.587786*scale, ["y"] = 0.000000*scale, ["z"] = 0.809017*scale},
						{ ["x"] =  -0.587786*scale, ["y"] = 0.000000*scale, ["z"] = -0.809017*scale},
						{ ["x"] =  -0.951058*scale, ["y"] = 0.000000*scale, ["z"] = -0.309013*scale},
						{ ["x"] =  0.587786*scale, ["y"] = 0.000000*scale, ["z"] = -0.809017*scale},
						{ ["x"] =  0.000000*scale, ["y"] = 0.000000*scale, ["z"] = -1.000000*scale},
						{ ["x"] =  0.688189*scale, ["y"] = 0.525736*scale, ["z"] = 0.499997*scale},
						{ ["x"] =  -0.262869*scale, ["y"] = 0.525738*scale, ["z"] = 0.809012*scale},
						{ ["x"] =  -0.850648*scale, ["y"] = 0.525736*scale, ["z"] = 0.000000*scale},
						{ ["x"] =  -0.262869*scale, ["y"] = 0.525738*scale, ["z"] = -0.809012*scale},
						{ ["x"] =  0.688189*scale, ["y"] = 0.525736*scale, ["z"] = -0.499997*scale},
						{ ["x"] =  0.162456*scale, ["y"] = 0.850654*scale, ["z"] = 0.499995*scale},
						{ ["x"] =  0.525730*scale, ["y"] = 0.850652*scale, ["z"] = 0.000000*scale},
						{ ["x"] =  -0.425323*scale, ["y"] = 0.850654*scale, ["z"] = 0.309011*scale},
						{ ["x"] =  -0.425323*scale, ["y"] = 0.850654*scale, ["z"] = -0.309011*scale},
						{ ["x"] =  0.162456*scale, ["y"] = 0.850654*scale, ["z"] = -0.499995*scale}
					},
				["FACES"] = {
						{ 1,14,13},
						{ 2,14,16},
						{ 1,13,18},
						{ 1,18,20},
						{ 1,20,17},
						{ 2,16,23},
						{ 3,15,25},
						{ 4,19,27},
						{ 5,21,29},
						{ 6,22,31},
						{ 2,23,26},
						{ 3,25,28},
						{ 4,27,30},
						{ 5,29,32},
						{ 6,31,24},
						{ 7,33,38},
						{ 8,34,40},
						{ 9,35,41},
						{ 10,36,42},
						{ 11,37,39},
						{ 39,42,12},
						{ 39,37,42},
						{ 37,10,42},
						{ 42,41,12},
						{ 42,36,41},
						{ 36,9,41},
						{ 41,40,12},
						{ 41,35,40},
						{ 35,8,40},
						{ 40,38,12},
						{ 40,34,38},
						{ 34,7,38},
						{ 38,39,12},
						{ 38,33,39},
						{ 33,11,39},
						{ 24,37,11},
						{ 24,31,37},
						{ 31,10,37},
						{ 32,36,10},
						{ 32,29,36},
						{ 29,9,36},
						{ 30,35,9},
						{ 30,27,35},
						{ 27,8,35},
						{ 28,34,8},
						{ 28,25,34},
						{ 25,7,34},
						{ 26,33,7},
						{ 26,23,33},
						{ 23,11,33},
						{ 31,32,10},
						{ 31,22,32},
						{ 22,5,32},
						{ 29,30,9},
						{ 29,21,30},
						{ 21,4,30},
						{ 27,28,8},
						{ 27,19,28},
						{ 19,3,28},
						{ 25,26,7},
						{ 25,15,26},
						{ 15,2,26},
						{ 23,24,11},
						{ 23,16,24},
						{ 16,6,24},
						{ 17,22,6},
						{ 17,20,22},
						{ 20,5,22},
						{ 20,21,5},
						{ 20,18,21},
						{ 18,4,21},
						{ 18,19,4},
						{ 18,13,19},
						{ 13,3,19},
						{ 16,17,6},
						{ 16,14,17},
						{ 14,1,17},
						{ 13,15,3},
						{ 13,14,15},
						{ 14,2,15}
					}
				}
	translate_3D(translate_3D(translate_3D(icosphere["VERTICES"], origin.x, "x"), origin.y, "y"), origin.z, "z")
	return icosphere

end

function screen_coordinates(data)
	local width, height = love.graphics.getDimensions()
	if #data >= 1 then
		for i=1, #data do
			data[i].x = data[i].x + width/2
			data[i].height = data[i].height - (data[i].y + height/2)
		end
		return data
	else
			data.x = data.x + width/2
			data.y = height - (data.y + height/2)
		return data
	end
end

-- Project a 3D point to a 2D plane
-- Assumes the projection plane lies at the world origin
-- The camera faces in the positive Z direction from (0,0,0)
function project_2D(data)
	if #data >= 1 then
		local projected = {}
		for i=1, #data do
			projected[#projected+1] = {
							["x"] = GLOBALVARS["DPI"] * (data[i].x / data[i].z),
							["y"] = GLOBALVARS["DPI"] * (data[i].y / data[i].z),
							}
		end
		return projected
	else
		return {
			 ["x"] = GLOBALVARS["DPI"] * (data.x / data.z),
			 ["y"] = GLOBALVARS["DPI"] * (data.y / data.z),
			}
	end
end

function love.load()
	love.graphics.setPointSize(10)

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
		p = GLOBALVARS["POINTS"][i]
		xs[#xs+1] = p.x
		ys[#ys+1] = p.y
		zs[#zs+1] = p.z
	end

	-- Translate the PDB from its center to world origin
	translate_3D(translate_3D(translate_3D(GLOBALVARS["POINTS"], -1*mean(xs), "x"), -1*mean(ys), "y"), -1*mean(zs), "z")

	local shapes = {}
	for i=1, #GLOBALVARS["POINTS"] do
		shapes[#shapes+1] = generate_icosphere(GLOBALVARS["POINTS"][i], 1, GLOBALVARS["POINTS"][i].e)
	end
	GLOBALVARS["SHAPES"] = shapes

end


function love.update(dt)
	for i=1, #GLOBALVARS["SHAPES"] do
		rotate_3D(GLOBALVARS["SHAPES"][i]["VERTICES"],0.5*dt, "x")
		rotate_3D(GLOBALVARS["SHAPES"][i]["VERTICES"],0.5*dt, "y")
		rotate_3D(GLOBALVARS["SHAPES"][i]["VERTICES"],0.5*dt, "z")
	end
end

function love.draw()

		local all_triangles = {}
		for i=1, #GLOBALVARS["SHAPES"] do -- for each shape (mesh)
			local shape = GLOBALVARS["SHAPES"][i]
			for j=1, #shape["FACES"] do -- lists all vertices which make up a triangle
				local triangle_verts = {}
				for k=1, 3 do -- for vertex in triange
					triangle_verts[#triangle_verts+1] = { -- append the vertex
								["x"] = shape["VERTICES"][shape["FACES"][j][k]].x,
								["y"] = shape["VERTICES"][shape["FACES"][j][k]].y,
								["z"] = shape["VERTICES"][shape["FACES"][j][k]].z,
								}
				end
	
				-- calculate triangle normal
				local normal = normal(triangle_verts[1], triangle_verts[2], triangle_verts[3])
				all_triangles[#all_triangles+1] = {
									["v1"] = triangle_verts[1],
									["v2"] = triangle_verts[2],
									["v3"] = triangle_verts[3],
									["pos"] = {["x"] = (triangle_verts[1].x+triangle_verts[2].x+triangle_verts[3].x)/3,
										   ["y"] = (triangle_verts[1].y+triangle_verts[2].y+triangle_verts[3].y)/3,
										   ["z"] = (triangle_verts[1].z+triangle_verts[2].z+triangle_verts[3].z)/3},
									["normal"] = normal,
									["element"] = shape["ELEMENT"]
								} 
			end
		end
		
		local backface_culled = {}
		for i=1, #all_triangles do
			if dot(all_triangles[i].normal, GLOBALVARS["CAMERA"]) < 0 then
				backface_culled[#backface_culled+1] = all_triangles[i]
			end
		end
				
		local magnitude_light_direction = mag(GLOBALVARS["LIGHT"])
		local light_dir_normalised = {
						["x"] = GLOBALVARS["LIGHT"].x / magnitude_light_direction,
						["y"] = GLOBALVARS["LIGHT"].y / magnitude_light_direction,
						["z"] = GLOBALVARS["LIGHT"].z / magnitude_light_direction,
					     }
		for i=1, #backface_culled do
			local light_intensity = dot(light_dir_normalised, backface_culled[i].normal)
			if backface_culled[i]["element"] == " C" then
				backface_culled[i]["colour"] = {["r"]= 1*light_intensity,
								["g"]= 0.41*light_intensity,
								["b"]= 0.38*light_intensity}
			else
				backface_culled[i]["colour"] = {["r"]= 1*light_intensity,
								["g"]= 0.32*light_intensity,
								["b"]= 0.28*light_intensity}
			end
		end

		-- painters algorithm, sort triangles buy Z distance
		-- in !!descending order!!
		table.sort(backface_culled, function(a,b) return a["pos"].z > b["pos"].z end)

		for i=1, #backface_culled do
			backface_culled[i]["v1"] = screen_coordinates(project_2D(translate_3D(backface_culled[i]["v1"], GLOBALVARS["ZOOM"], "z")))
			backface_culled[i]["v2"] = screen_coordinates(project_2D(translate_3D(backface_culled[i]["v2"], GLOBALVARS["ZOOM"], "z")))
			backface_culled[i]["v3"] = screen_coordinates(project_2D(translate_3D(backface_culled[i]["v3"], GLOBALVARS["ZOOM"], "z")))
			love.graphics.setColor(backface_culled[i].colour["r"], backface_culled[i].colour["g"], backface_culled[i].colour["b"], 1)
			love.graphics.polygon("fill", backface_culled[i]["v1"].x, backface_culled[i]["v1"].y,
						backface_culled[i]["v2"].x, backface_culled[i]["v2"].y,
						backface_culled[i]["v3"].x,backface_culled[i]["v3"].y )
		end
		
end


function translate_3D(data, distance, axis)
	if #data >= 1 then
		if axis == "x" then
			for i=1, #data do
				data[i].x = data[i].x+distance
			end
		elseif axis == "y" then
			for i=1, #data do
				data[i].y = data[i].y+distance
			end
		elseif axis == "z" then
			for i=1, #data do
				data[i].z = data[i].z+distance
			end

		end
		return data
	else
		if axis == "x" then
			data.x = data.x+distance
		elseif axis == "y" then
			data.y = data.y+distance
		elseif axis == "z" then
			data.z = data.z+distance
		end
	return data	
	end
end

function rotate_3D(data, theta, axis)
	
	local sin = math.sin
	local cos = math.cos
	local rotate_3D_x = {
				{1,0,0},
				{0, cos(theta), -sin(theta)},
				{0, sin(theta), cos(theta)}
			    }
	local rotate_3D_y = {
				{cos(theta),0,-sin(theta)},
				{0, 1, 0},
				{sin(theta),0 , cos(theta)}
			    }
	local rotate_3D_z = {
				{cos(theta),-sin(theta),0},
				{sin(theta), cos(theta), 0},
				{0, 0, 1}
			    }

	if axis == "x" then
		for i=1, #data do
			data[i].x = rotate_3D_x[1][1] * data[i].x + rotate_3D_x[1][2] * data[i].y + rotate_3D_x[1][3] * data[i].z
			data[i].y = rotate_3D_x[2][1] * data[i].x + rotate_3D_x[2][2] * data[i].y + rotate_3D_x[2][3] * data[i].z
			data[i].z = rotate_3D_x[3][1] * data[i].x + rotate_3D_x[3][2] * data[i].y + rotate_3D_x[3][3] * data[i].z
							       
		end
	elseif axis == "y" then
		for i=1, #data do
			data[i].x = rotate_3D_y[1][1] * data[i].x + rotate_3D_y[1][2] * data[i].y + rotate_3D_y[1][3] * data[i].z
			data[i].y = rotate_3D_y[2][1] * data[i].x + rotate_3D_y[2][2] * data[i].y + rotate_3D_y[2][3] * data[i].z
			data[i].z = rotate_3D_y[3][1] * data[i].x + rotate_3D_y[3][2] * data[i].y + rotate_3D_y[3][3] * data[i].z
		end
	elseif axis == "z" then
		for i=1, #data do
			data[i].x = rotate_3D_z[1][1] * data[i].x + rotate_3D_z[1][2] * data[i].y + rotate_3D_z[1][3] * data[i].z
			data[i].y = rotate_3D_z[2][1] * data[i].x + rotate_3D_z[2][2] * data[i].y + rotate_3D_z[2][3] * data[i].z
			data[i].z = rotate_3D_z[3][1] * data[i].x + rotate_3D_z[3][2] * data[i].y + rotate_3D_z[3][3] * data[i].z
		end
	end
	return data

end

-- Assumes clockwise winding order
function normal(vert3D_1, vert3D_2, vert3D_3)

	local vector_v1v2 = {["x"] = vert3D_2.x-vert3D_1.x, ["y"] = vert3D_2.y-vert3D_1.y, ["z"] = vert3D_2.z-vert3D_1.z}
	local vector_v1v3 = {["x"] = vert3D_3.x-vert3D_1.x, ["y"] = vert3D_3.y-vert3D_1.y, ["z"] = vert3D_3.z-vert3D_1.z}

	local cross_product = cross(vector_v1v2, vector_v1v3)
	local magnitude = mag(cross_product)
	return {
		["x"] = cross_product.x / magnitude,
		["y"] = cross_product.y / magnitude,
		["z"] = cross_product.z / magnitude
		}
end

function mag(vec3D)
	return math.sqrt(vec3D.x^2 + vec3D.y^2 + vec3D.z^2)
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
