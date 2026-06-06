local pdbfile = "1hrc.pdb"

local GLOBALVARS = {
			["DPI"] = 1000, -- "Pixels per PDB unit"
			["ZOOM"] = 35,
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

--[[
GLOBALVARS["POINTS"] = {
			{["x"] = 0, ["y"] = 0, ["z"] = 0, ["e"] = "C"}, }
--[[
			{["x"] = 5, ["y"] = 5, ["z"] = 2, ["e"] = "C"},
			{["x"] = 0, ["y"] = 0, ["z"] = -1, ["e"] = "O"},
			{["x"] = 15, ["y"] = 15, ["z"] = 4, ["e"] = "C"},
			{["x"] = 20, ["y"] = 20, ["z"] = 3, ["e"] = "O"},
			}
--]]

function generate_icosphere(origin, scale, colour)
	local icosphere = {
				["COLOUR"] = colour, --RGB
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
						{1,14,13},
						{2,14,16},
						{1,13,18},
						{1,18,20},
						{1,20,17},
						{2,16,23},
						{3,15,25},
						{4,19,27},
						{5,21,29},
						{6,22,31},
						{2,23,26},
						{3,25,28},
						{4,27,30},
						{5,29,32},
						{6,31,24},
						{7,33,38},
						{8,34,40},
						{9,35,41},
						{10,36,42},
						{11,37,39},
						{39,42,12},
						{39,37,42},
						{37,10,42},
						{42,41,12},
						{42,36,41},
						{ 36,9,41},
						{41,40,12},
						{41,35,40},
						{35,8,40},
						{40,38,12},
						{40,34,38},
						{34,7,38},
						{38,39,12},
						{38,33,39},
						{33,11,39},
						{24,37,11},
						{24,31,37},
						{31,10,37},
						{32,36,10},
						{32,29,36},
						{29,9,36},
						{30,35,9},
						{30,27,35},
						{27,8,35},
						{28,34,8},
						{28,25,34},
						{25,7,34},
						{26,33,7},
						{26,23,33},
						{23,11,33},
						{31,32,10},
						{31,22,32},
						{22,5,32},
						{29,30,9},
						{29,21,30},
						{21,4,30},
						{27,28,8},
						{27,19,28},
						{19,3,28},
						{ 25,26,7},
						{25,15,26},
						{15,2,26},
						{23,24,11},
						{23,16,24},
						{16,6,24},
						{17,22,6},
						{17,20,22},
						{20,5,22},
						{20,21,5},
						{20,18,21},
						{18,4,21},
						{18,19,4},
						{18,13,19},
						{13,3,19},
						{16,17,6},
						{16,14,17},
						{14,1,17},
						{13,15,3},
						{13,14,15},
						{14,2,15}
					}
				}
	translate_3D(icosphere["VERTICES"], origin.x, origin.y, origin.z)
	return icosphere

end

function screen_coordinates(triangles, width, height)	
	local half_height = height/2
	local half_width = width/2

	for i=1, #triangles do	
		local triangle = triangles[i]
		local v1 = triangle["v1"]
		local v2 = triangle["v2"]
		local v3 = triangle["v3"]

		v1.x = v1.x + half_width
		v1.y = height - (v1.y + half_height)

		v2.x = v2.x + half_width
		v2.y = height - (v2.y + half_height)

		v3.x = v3.x + half_width
		v3.y = height - (v3.y + half_height)
	end
end

-- Project a 3D point to a 2D plane
-- Assumes the projection plane lies at the world origin
-- The camera faces in the positive Z direction from (0,0,0)
function project_2D(triangles, zoom, dpi)
	for i=1, #triangles do
		local triangle = triangles[i]
		local v1 = triangle["v1"]
		local v2 = triangle["v2"]
		local v3 = triangle["v3"]
			 
		v1.x = dpi * (v1.x / (v1.z+zoom))
		v1.y = dpi * (v1.y / (v1.z+zoom))

		v2.x = dpi * (v2.x / (v2.z+zoom))
		v2.y = dpi * (v2.y / (v2.z+zoom))

		v3.x = dpi * (v3.x / (v3.z+zoom))
		v3.y = dpi * (v3.y / (v3.z+zoom))
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
		xs[#xs+1] = p.x
		ys[#ys+1] = p.y
		zs[#zs+1] = p.z
	end

	-- Translate the PDB from its center to world origin
	translate_3D(GLOBALVARS["POINTS"], -1*mean(xs), -1*mean(ys), -1*mean(zs))

	local shapes = {}
	for i=1, #GLOBALVARS["POINTS"] do
		if GLOBALVARS["POINTS"][i].e == "C" then
			local colour = {["r"]=1,
					["g"]=0.41,
					["b"]=0.38}
			shapes[#shapes+1] = generate_icosphere(GLOBALVARS["POINTS"][i], 1, colour)
		else
			local colour = {["r"]=1,
					["g"]=0.32,
					["b"]=0.28}
			shapes[#shapes+1] = generate_icosphere(GLOBALVARS["POINTS"][i], 1, colour)
		end
	end
	GLOBALVARS["SHAPES"] = shapes

end

function love.resize(w,h)
	local width, height = love.graphics.getDimensions()
	GLOBALVARS["SCREEN"] = {["x"] = width, ["y"] = height} 
end

love.frame=0
function love.update(dt)
	for i=1, #GLOBALVARS["SHAPES"] do
		local vertices = GLOBALVARS["SHAPES"][i]["VERTICES"]
		rotate_3D(vertices,0.01,0.01,0.01)
	end
	--[[
	if love.frame%1 == 0 then	
		love.report = love.profiler.report(20)
		print(love.report)
		love.profiler.reset()
	end
	love.frame = love.frame + 1
	--]]
end

function love.draw()

		local dpi = GLOBALVARS["DPI"]
		local zoom = GLOBALVARS["ZOOM"]
		local camera = GLOBALVARS["CAMERA"]
		local width = GLOBALVARS["SCREEN"].x
		local height = GLOBALVARS["SCREEN"].y 


		local sort = table.sort
		local all_triangles = {}

		for i=1, #GLOBALVARS["SHAPES"] do -- for each shape (mesh)

			local shape = GLOBALVARS["SHAPES"][i]
			local faces = shape["FACES"]
			local vertices = shape["VERTICES"]

			for j=1, #faces do -- lists all vertices which make up a triangle	
				local triangle_verts = {{["x"] = 0, ["y"] = 0, ["z"] = 0},
							{["x"] = 0, ["y"] = 0, ["z"] = 0},
							{["x"] = 0, ["y"] = 0, ["z"] = 0}}
				for k=1, 3 do -- for vertex in triangle
					triangle_verts[k].x = vertices[faces[j][k]].x
					triangle_verts[k].y = vertices[faces[j][k]].y
					triangle_verts[k].z = vertices[faces[j][k]].z
				end

				-- calculate triangle normal
				local normal = normal(triangle_verts[1], triangle_verts[2], triangle_verts[3])
				local dot_product = dot(normal, camera)

				if dot_product < 0 then -- backface culling
					local inverse_dot = -1*dot_product
					all_triangles[#all_triangles+1] = {
							["v1"] = triangle_verts[1],
							["v2"] = triangle_verts[2],
							["v3"] = triangle_verts[3],
							["zpos"] = (triangle_verts[1].z+triangle_verts[2].z+triangle_verts[3].z)/3,
							["colour"] = {["r"] = shape["COLOUR"].r * inverse_dot,
								      ["g"] = shape["COLOUR"].g * inverse_dot,
								      ["b"] = shape["COLOUR"].b * inverse_dot,
								     }
							} 
				end

			end
		end

		-- painters algorithm, sort triangles buy Z distance
		-- in !!descending order!!
		sort(all_triangles, function(a,b) return a.zpos > b.zpos end)

		project_2D(all_triangles, zoom, dpi)
		screen_coordinates(all_triangles, width, height)
		for i=1, #all_triangles do
			local triangle = all_triangles[i]
			love.graphics.setColor(triangle.colour["r"], triangle.colour["g"], triangle.colour["b"], 1)
			love.graphics.polygon("fill", triangle.v1.x, triangle.v1.y, triangle.v2.x, triangle.v2.y, triangle.v3.x, triangle.v3.y )
		end
	
end


function translate_3D(data, distance_x, distance_y, distance_z)
	if #data >= 1 then
		for i=1, #data do
			data[i].x = data[i].x+distance_x
			data[i].y = data[i].y+distance_y
			data[i].z = data[i].z+distance_z
		end
		return data
	else
		data.x = data.x+distance_x
		data.y = data.y+distance_y
		data.z = data.z+distance_z
	return data	
	end
end

function rotate_3D(data, theta_x, theta_y, theta_z)
	
	local sin = math.sin
	local cos = math.cos
	
	local rotate_3D_x = {
				{1,0,0},
				{0, cos(theta_x), -sin(theta_x)},
				{0, sin(theta_x), cos(theta_x)}
			    }
	local rotate_3D_y = {
				{cos(theta_y),0,sin(theta_y)},
				{0, 1, 0},
				{-sin(theta_y),0 , cos(theta_y)}
			    }
	local rotate_3D_z = {
				{cos(theta_z),-sin(theta_z),0},
				{sin(theta_z), cos(theta_z), 0},
				{0, 0, 1}
			    }

	for i=1, #data do
		local output_rx_x = rotate_3D_x[1][1] * data[i].x + rotate_3D_x[1][2] * data[i].y + rotate_3D_x[1][3] * data[i].z
		local output_rx_y = rotate_3D_x[2][1] * data[i].x + rotate_3D_x[2][2] * data[i].y + rotate_3D_x[2][3] * data[i].z
		local output_rx_z = rotate_3D_x[3][1] * data[i].x + rotate_3D_x[3][2] * data[i].y + rotate_3D_x[3][3] * data[i].z

		local output_ry_x = rotate_3D_y[1][1] * output_rx_x + rotate_3D_y[1][2] * output_rx_y + rotate_3D_y[1][3] * output_rx_z
		local output_ry_y = rotate_3D_y[2][1] * output_rx_x + rotate_3D_y[2][2] * output_rx_y + rotate_3D_y[2][3] * output_rx_z
		local output_ry_z = rotate_3D_y[3][1] * output_rx_x + rotate_3D_y[3][2] * output_rx_y + rotate_3D_y[3][3] * output_rx_z

		data[i].x = rotate_3D_z[1][1] * output_ry_x + rotate_3D_z[1][2] * output_ry_y + rotate_3D_z[1][3] * output_ry_z
		data[i].y = rotate_3D_z[2][1] * output_ry_x + rotate_3D_z[2][2] * output_ry_y + rotate_3D_z[2][3] * output_ry_z
		data[i].z = rotate_3D_z[3][1] * output_ry_x + rotate_3D_z[3][2] * output_ry_y + rotate_3D_z[3][3] * output_ry_z
	end
end

-- Assumes clockwise winding order
function normal(vert3D_1, vert3D_2, vert3D_3)
	local sqrt = math.sqrt
	local vector_v1v2 = {["x"] = vert3D_2.x-vert3D_1.x, ["y"] = vert3D_2.y-vert3D_1.y, ["z"] = vert3D_2.z-vert3D_1.z}
	local vector_v1v3 = {["x"] = vert3D_3.x-vert3D_1.x, ["y"] = vert3D_3.y-vert3D_1.y, ["z"] = vert3D_3.z-vert3D_1.z}

	local cross_product = {
				["x"] = vector_v1v2.y*vector_v1v3.z - vector_v1v2.z*vector_v1v3.y,
				["y"] = vector_v1v2.z*vector_v1v3.x - vector_v1v2.x*vector_v1v3.z,
				["z"] = vector_v1v2.x*vector_v1v3.y - vector_v1v2.y*vector_v1v3.x
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
