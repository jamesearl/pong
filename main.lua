game = {}
game.ball = {}
game.paddle = {}
game.enemy = {}
game.score = {}

function love.draw()

	love.graphics.rectangle("fill", game.enemy.body:getX(), game.enemy.body:getY(), game.enemy.width, game.enemy.height)

	love.graphics.rectangle("fill", game.paddle.body:getX(), game.paddle.body:getY(), game.paddle.width, game.paddle.height)
	
	love.graphics.circle("fill", game.ball.body:getX(), game.ball.body:getY(), game.ball.shape:getRadius(), 20)

	love.graphics.print(game.score.player, 20, 10)
	love.graphics.print(game.score.computer, 620, 10)
end

function love.keypressed(key, unicode)
 	if key == 'left' then
		game.ball.body:applyForce(-200, 0)
	elseif key == "right" then
		game.ball.body:applyForce(200, 0)
	elseif key == "up" then
		game.ball.body:applyForce(0, -200)
	elseif key == "down" then
		game.ball.body:applyForce(0, 200)
 	end
end

function love.load()
	

	game.world = love.physics.newWorld(0, 0, 650, 650)

	game.ball.radius = 5
	game.ball.mass = 15
	game.ball.body = love.physics.newBody(game.world, 650/2, 650/2, game.ball.mass, 0)
	game.ball.shape = love.physics.newCircleShape(game.ball.body, 0, 0, game.ball.radius)

	game.paddle.width = 5
	game.paddle.height = 30
	game.paddle.mass = 0
	game.paddle.body = love.physics.newBody(game.world, 10, 300, game.paddle.mass, 0)
	game.paddle.shape = love.physics.newRectangleShape(game.paddle.body, game.paddle.width/2, game.paddle.height/2, game.paddle.width, game.paddle.height, 0)

	game.enemy.width = 5
	game.enemy.height = 30
	game.enemy.mass = 0
	game.enemy.body = love.physics.newBody(game.world, 590, 300, game.enemy.mass, 0)
	game.enemy.shape = love.physics.newRectangleShape(game.enemy.body, game.enemy.width/2, game.enemy.height/2, game.enemy.width, game.enemy.height, 0)

	game.score.player = 0
	game.score.computer = 0

	game.world:setGravity(0, 0)
	game.world:setMeter(32)
	game.world:setCallbacks(add, persist, remove, result)

end

function love.quit()
	--game = nil
end

function love.update(dt)
	game.world:update(dt)

	vx, vy = game.ball.body:getLinearVelocity()
	bx = game.ball.body:getX()
	by = game.ball.body:getY()

	if bx <= game.ball.radius or bx >= 650-game.ball.radius then -- collision with a window border
		game.ball.reset()
		if bx <= game.ball.radius then --left
			game.score.computer = game.score.computer + 1
		else
			game.score.player = game.score.player + 1
		end
		--game.ball.invertHorizontalVelocity()
	end

	if by <= game.ball.radius or by >= 650-game.ball.radius then -- ""
		game.ball.invertVerticalVelocity()
	end

	game.paddle.body:setY(love.mouse:getY())

	game.enemy.doAI(dt)
end

function game.enemy.doAI(dt)
	--basic AI, move towards the ball always
	if game.enemy.body:getY()+(game.enemy.height/2) < (by + game.ball.radius) then
		game.enemy.body:setY(game.enemy.body:getY() + 2)
	else
		game.enemy.body:setY(game.enemy.body:getY() - 2)
	end
end

function game.ball.reset()
	game.ball.body:setX(650/2)
	game.ball.body:setY(650/2)
	game.ball.body:setLinearVelocity(0,0)
end

function game.ball.invertHorizontalVelocity()
	if vx < 0 then
		game.ball.body:setLinearVelocity( math.abs(vx), vy )
	else
		game.ball.body:setLinearVelocity( 0-vx, vy )
	end
end

function game.ball.invertVerticalVelocity()
	if vy < 0 then
		game.ball.body:setLinearVelocity( vx, math.abs(vy) )
	else
		game.ball.body:setLinearVelocity( vx, 0-vy )
	end
end

function game.ball.increaseHorizontalVelocity(x)
	if vx < 0 then
		game.ball.body:setLinearVelocity(vx - x, vy)
	else
		game.ball.body:setLinearVelocity(vx + x, vy)
	end
end

function game.ball.increaseVerticalVelocity(y)
	if vy < 0 then
		game.ball.body:setLinearVelocity(vx, vy - y)
	else
		game.ball.body:setLinearVelocity(vx, vy + y)
	end
end

function add(a, b, coll)
	game.ball.invertHorizontalVelocity()
end

function persist(a, b, coll)

end

function remove(a, b, coll)
	game.ball.increaseHorizontalVelocity(50)

	-- change vertical velocity by a bit
	game.ball.increaseVerticalVelocity(20)
end

function result(a, b, coll)

end
