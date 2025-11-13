player = {}

function player:load()
    self.x = 100
    self.y = 0
    self.width = 20
    self.height = 60
    self.xVel = 0
    self.yVel = 100
    self.maxspeed = 200
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
end

function player:applyegravity(dt)
    if not self.ground then
        self.yVel = self.yVel + self.gravity * dt
    end
end

function player:update(dt)
    self:syncphysics()
    player:move(dt)
    player:applyegravity(dt)
    player:jump()
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
    if key == "space" then
        self.yVel = self.jumpAmount
    end
end

function player:land()
    self.yVel = 0
    self.ground = true
end

function player:endContact(a, b, collision)
    self.ground = false
end

function player:move(dt)
    if love.keyboard.isDown("right", "d") then
        if self.xVel < self.maxspeed then
            if self.xVel + self.acceleration * dt < self.maxspeed then
                self.xVel = self.xVel + self.acceleration * dt
            else
                self.xVel = self.maxspeed
            end
        end
    elseif love.keyboard.isDown("left", "a") then
        if self.xVel > -self.maxspeed then
            if self.xVel - self.acceleration * dt > -self.maxspeed then
                self.xVel = self.xVel - self.acceleration * dt
            else
                self.xVel = -self.maxspeed
            end
        end
    else
        self:applyeFriction(dt)
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
    love.graphics.rectangle("fill",
        self.x - self.width / 2,
        self.y - self.height / 2,
        self.width,
        self.height
    )
end
