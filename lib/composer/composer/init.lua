local PATH = (...):gsub('%.init$', '')

local M = {
    _VERSION = "0.1.0",
    _DESCRIPTION = "A simple layout engine",
    _URL = "https://github.com/wolf81/composer",
    _LICENSE = [[ TBD ]], 
}

M.Rect = require(PATH .. '.rect')

return M