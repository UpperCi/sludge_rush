File_Loader = Class:extend()


function in_table(t, v)
	for _, value in ipairs(t) do
		if value == v then
			return true
		end
	end
	return false
end

function File_Loader:new()
    self.files = {}
    self.loaded_files = {}
end

function File_Loader:load_files(files)
    for _, file in ipairs(files) do
        table.insert(self.files, file)
    end
end

function File_Loader:load_folder(folder)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        local file_type = love.filesystem.getInfo(file).type
        
        if file_type == "file" then
            table.insert(self.files, file)
        elseif file_type == "directory" then
            self:load_folder(file)
        end
    end
end

function File_Loader:require()
    for _, file in ipairs(self.files) do
        local file = file:sub(1, -5)
        if not in_table(self.loaded_files, file) then
            require(file)
            table.insert(self.loaded_files, file)
        end
    end

    self.files = {}
end
