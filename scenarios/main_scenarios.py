
from pydrivingsim import TrafficLight, Target, TrafficCone, SuggestedSpeedSignal, GraphicObject, Vehicle, Agent, Coin, Rock, RoadSegment, World, GPS, Graph

class OnlyVehicle():
    def __init__(self):
        #Initialize the vehicle
        self.vehicle = Vehicle()
        self.vehicle.set_screen_here()
        self.vehicle.set_pos_ang((0, -1, 0))

        #Initialize target
        target = Target()
        target.set_pos((182, -1))
        target.set_object(self.vehicle)

    def update(self):
        self.vehicle.set_screen_here()
        self.vehicle.control([0.5, 0.0])

    def terminate(self):
        pass

class AutonomousVehicle():
    def __init__(self):
        # Initialize the vehicle
        self.vehicle = Vehicle()
        self.vehicle.set_screen_here()
        self.vehicle.set_pos_ang((0, -1, 0))
        self.gps = GPS(self.vehicle)

        #Initialize the agent
        self.agent = Agent(self.vehicle)

    def update(self):
        self.agent.compute()
        action = self.agent.get_action()

        self.vehicle.set_screen_here()
        self.vehicle.control([action[0], action[1]])

    def terminate(self):
        self.agent.terminate()

# draw path into m.m.TrajectoryPointIX
class DrawPath():
    def __init__(self):
        self.graph = Graph()

class Scenario_BasicTL():
    def __init__(self, av):
    
        # draw the background image
        World().set_background("imgs/bg.jpeg", bg_pos=(-1100,-1745))
    
        # draw the rectangle of terrain
        # (x, y) is the CENTER of the segment
        segm = RoadSegment(x=90, y=0, length=270, width=4, terrain_type="asphalt")
        
        # draw the vehicle
        # remove and add the vehicle to put it in the focus
        if av.vehicle in World().obj_list:
            World().obj_list.remove(av.vehicle)
        World().obj_list.append(av.vehicle)
        av.vehicle.set_pos_ang((0,-1,0))
        
        #Initialize target
        target = Target()
        target.set_pos((182, -1))
        target.set_object(av.vehicle)
        
        # draw the cones
        cone = TrafficCone()
        cone.set_pos((1.0,0))
        cone = TrafficCone()
        cone.set_pos((1.0,2))
        cone = TrafficCone()
        cone.set_pos((1.0,-2))
        
        # draw the rocks
        #rock = Rock()
        #rock.set_pos_size((1, -5), 2.0, 2.0)
        #rock = Rock()
        #rock.set_pos_size((1, 5), 1.0, 1.0)

        # set pos of the TL
        trafficlight = TrafficLight()
        trafficlight.set_pos((160,-3))
        trafficlight.reset()
        
        # Enable this to test the coins
        #GetTheCoins()
        # Enable this to test the speed limit
        #BasicSpeedLimit()

class GetTheCoins():
    def __init__(self):
        # Added point in zero to be able to start with a reference
        coin = Coin()
        coin.set_pos((0,-1))

        # Targets to avoid cones
        coin = Coin()
        coin.set_pos((10,-1))
        coin = Coin()
        coin.set_pos((35,1))
        coin = Coin()
        coin.set_pos((60,-1))
        coin = Coin()
        coin.set_pos((100,1))
        coin = Coin()
        coin.set_pos((130,-1))

        # Add two final points to stabilize the trajectory
        coin = Coin()
        coin.set_pos((160,-1))
        coin = Coin()
        coin.set_pos((182,-1))


class BasicSpeedLimit():
    def __init__(self):
        signal = SuggestedSpeedSignal(10)
        signal.set_pos((50, 4))
        bologna = GraphicObject("imgs/pictures/bologna.png", 35)
        bologna.set_pos((67,12))
        signal = SuggestedSpeedSignal(90)
        signal.set_pos((96, 4))
        super = GraphicObject("imgs/pictures/superstrada.png", 5)
        super.set_pos((100,6))
        
class Scenario1():
    def __init__(self, av):
        # draw the background image
        World().set_background("imgs/Scenario_1.png", bg_pos=(-1100,-1745))
        
        # draw the rectangle of terrain
        segm = RoadSegment(x=0, y=0, length=6, width=100, terrain_type="asphalt")
        segm = RoadSegment(x=33, y=46, length=60, width=8, terrain_type="asphalt")
        segm = RoadSegment(x=66, y=0, length=6, width=100, terrain_type="asphalt")
        segm = RoadSegment(x=99, y=-46, length=60, width=8, terrain_type="asphalt")
        segm = RoadSegment(x=132, y=0, length=6, width=100, terrain_type="dirt")
        segm = RoadSegment(x=165, y=46, length=60, width=8, terrain_type="asphalt")
        
        # draw the vehicle
        # remove and add the vehicle to put it in the focus
        if av.vehicle in World().obj_list:
            World().obj_list.remove(av.vehicle)
        World().obj_list.append(av.vehicle)
        av.vehicle.set_pos_ang((0, -40, 1.57)) #((0,-1,0.1))
        
        #Initialize target
        target = Target()
        target.set_pos((175, 46))
        target.set_object(av.vehicle)
        
        # draw the cones
        cone = TrafficCone()
        cone.set_pos((63.5, 10))
        cone = TrafficCone()
        cone.set_pos((65, 10))
        cone = TrafficCone()
        cone.set_pos((67, -20))
        cone = TrafficCone()
        cone.set_pos((68.5, -20))
        
        # draw the rocks
        rock = Rock()
        rock.set_pos_size((130, -5), 2.0, 2.0)
        rock = Rock()
        rock.set_pos_size((134, 15), 2.0, 3.0)