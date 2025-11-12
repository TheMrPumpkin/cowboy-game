local STI = require("assets/libraries/sti")
 require("player")

function love.load()
    map = STI("assets/tiles/map.lua", {"box2d"})
    world = love.physics.newWorld(0,0)
    map:box2d_init(world)
    map.layers.solid.visible = false
    background = love.graphics.newImage("assets/sprites/bluesky.jpg")
    player:load()
    world:setCallbacks(beginContact , endContact)
end

function love.update(dt)
    world:update(dt)
    player:update(dt)
end

function love.draw()
    love.graphics.draw(background)
    map:draw(0, 0, 2, 2)
    love.graphics.push()
    love.graphics.scale(2,2)
    player:draw()
    love.graphics.pop()


    
end


function love.keypressed(key)
    player:jump(key)
end


function beginContact(a, b, collision)
    player:beginContact(a, b, collision)
end
    
function endContact(a, b, collision)
    player:endContact(a, b, collision)
end