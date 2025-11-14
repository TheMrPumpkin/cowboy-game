player = {}

love.graphics.setDefaultFilter("nearest", "nearest")

function player:load()
    self.x = 100
    self.y = 0

    self.width = 32
    self.height = 32

    self.xVel = 0
    self.yVel = 100
    self.maxspeed = 100
    self.acceleration = 4000
    self.friction = 3500
    self.gravity = 1500
    self.ground = false
    self.jumpAmount = -500

    self.physics = {}
    self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

    self.spriteSheet = love.graphics.newImage("assets/sprites/player.png")
    local anim8 = require 'assets.libraries.anim8'
    self.grid = anim8.newGrid(32, 32,
        self.spriteSheet:getWidth(),
        self.spriteSheet:getHeight()
    )
    self.animation = {}
    self.animation.idle = anim8.newAnimation(self.grid('1-2', 1), 0.2)
    self.animation.walk = anim8.newAnimation(self.grid('2-5', 1), 0.2)

    self.currentAnim = self.animation.idle  
end

function player:applyegravity(dt)
    if not self.ground then
        self.yVel = self.yVel + self.gravity * dt
    end
end

function player:update(dt)
    self:syncphysics()
    self:move(dt)
  --  self:applyegravity(dt)
end

function player:syncphysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function player:beginContact(a, b, collision)
    if self.ground == true then return end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land()
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land()
        end
    end
end

function player:jump(key)
   
end

function player:land()
    self.yVel = 0
    self.ground = true
end

function player:endContact(a, b, collision)
    self.ground = false
end

function player:move(dt)
    local moving = false

    if love.keyboard.isDown("right", "d") then
        if self.xVel < self.maxspeed then
            local new = self.xVel + self.acceleration * dt
            if new < self.maxspeed then
                self.xVel = new
            else
                self.xVel = self.maxspeed
            end
        end
        moving = true
    elseif love.keyboard.isDown("left", "a") then
        if self.xVel > -self.maxspeed then
            local new = self.xVel - self.acceleration * dt
            if new > -self.maxspeed then
                self.xVel = new
            else
                self.xVel = -self.maxspeed
            end
        end
        moving = true
    else
        self:applyFrictionX(dt)
    end

    if love.keyboard.isDown("down", "s") then
        if self.yVel < self.maxspeed then
            local new = self.yVel + self.acceleration * dt
            if new < self.maxspeed then
                self.yVel = new
            else
                self.yVel = self.maxspeed
            end
        end
        moving = true

    elseif love.keyboard.isDown("up", "w") then
        if self.yVel > -self.maxspeed then
            local new = self.yVel - self.acceleration * dt
            if new > -self.maxspeed then
                self.yVel = new
            else
                self.yVel = -self.maxspeed
            end
        end
        moving = true
    else
        self:applyFrictionY(dt)
    end

     
    if moving then
        self.currentAnim = self.animation.walk
    else
        self.currentAnim = self.animation.idle
    end

    self.currentAnim:update(dt)   
end

function player:applyFrictionX(dt)
    if self.xVel > 0 then
        self.xVel = self.xVel - self.friction * dt
        if self.xVel < 0 then self.xVel = 0 end
    elseif self.xVel < 0 then
        self.xVel = self.xVel + self.friction * dt
        if self.xVel > 0 then self.xVel = 0 end
    end
end

function player:applyFrictionY(dt)
    if self.yVel > 0 then
        self.yVel = self.yVel - self.friction * dt
        if self.yVel < 0 then self.yVel = 0 end
    elseif self.yVel < 0 then
        self.yVel = self.yVel + self.friction * dt
        if self.yVel > 0 then self.yVel = 0 end
    end
end

function player:applyeFriction(dt)
    if self.xVel > 0 then
        if self.xVel - self.friction * dt > 0 then
            self.xVel = self.xVel - self.friction * dt
        else
            self.xVel = 0
        end
    elseif self.xVel < 0 then
        if self.xVel + self.friction * dt < 0 then
            self.xVel = self.xVel + self.friction * dt
        else
            self.xVel = 0
        end
    end
end

function player:draw()
    local frameWidth, frameHeight = 32, 32
    local scale = 2

    local originX = frameWidth / 2
    local originY = frameHeight / 2

    self.currentAnim:draw(
        self.spriteSheet,
        self.x, self.y,   
        0,
        scale, scale,
        originX, originY
    )
end