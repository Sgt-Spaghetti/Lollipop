local parser = {}

function load_OBJ(filepath, scale)

	local scale = scale or 1

	function normalise(x, y, z, w)
		local magnitude = math.sqrt(x^2 + y^2 + z^2)
		return {x/magnitude, y/magnitude, z/magnitude, 0}
	end

	local mesh = {
		["TRIANGLES"] = {},
	}

	local file = io.open(filepath, "r")

	local vertices = {}
	local normals = {}

	for line in file:lines() do
		local attribute = line:sub(1,2)
		if attribute == "v " then
			local x, y, z = line:match("v (-?%d+%.?%d+) (-?%d+%.?%d+) (-?%d+%.?%d+)")
			vertices[#vertices+1] = {tonumber(x)*scale, tonumber(y)*scale, tonumber(z)*scale}

		elseif attribute == "vn" then
			local x, y, z = line:match("vn (-?%d+%.?%d+) (-?%d+%.?%d+) (-?%d+%.?%d+)")
			normals[#normals+1] = normalise(tonumber(x), tonumber(y), tonumber(z), 0)
		
		elseif attribute == "f " then
			local v1, v1n, v2, v2n, v3, v3n = line:match("f (%d+)/%d*/(%d+) (%d+)/%d*/(%d+) (%d+)/%d*/(%d+)")
			mesh["TRIANGLES"][#mesh["TRIANGLES"]+1] = {
									vertices[tonumber(v1)][1],
									vertices[tonumber(v1)][2],
									vertices[tonumber(v1)][3],
									normals[tonumber(v1n)][1],
									normals[tonumber(v1n)][2],
									normals[tonumber(v1n)][3],
									0,
									1,1,1,1,
								   }
			mesh["TRIANGLES"][#mesh["TRIANGLES"]+1] = {
									vertices[tonumber(v2)][1],
									vertices[tonumber(v2)][2],
									vertices[tonumber(v2)][3],
									normals[tonumber(v2n)][1],
									normals[tonumber(v2n)][2],
									normals[tonumber(v2n)][3],
									0,
									1,1,1,1,
								   }
			mesh["TRIANGLES"][#mesh["TRIANGLES"]+1] = {
									vertices[tonumber(v3)][1],
									vertices[tonumber(v3)][2],
									vertices[tonumber(v3)][3],
									normals[tonumber(v3n)][1],
									normals[tonumber(v3n)][2],
									normals[tonumber(v3n)][3],
									0,
									1,1,1,1,
								   }
		end
	end

	file:close()

	return mesh

end


function instance(object)
	local instance = {["TRIANGLES"] = {}}
	for i=1, #object["TRIANGLES"] do
		instance["TRIANGLES"][i] = {object["TRIANGLES"][i][1], object["TRIANGLES"][i][2], object["TRIANGLES"][i][3], object["TRIANGLES"][i][4], object["TRIANGLES"][i][5], object["TRIANGLES"][i][6],0,1,1,1,1}
	end
	return instance	
end

parser.load_OBJ = load_OBJ
parser.instance = instance

return parser
