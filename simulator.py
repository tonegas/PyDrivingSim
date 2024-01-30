# Authors : Gastone Pietro Rosati Papini
# Date    : 09/08/2022
# License : MIT
import math
import signal

from pydrivingsim import World, Vehicle, TrafficLight, Agent, Target, TrafficCone, SuggestedSpeedSignal, GraphicObject

class GracefulKiller:
  kill_now = False
  def __init__(self):
    signal.signal(signal.SIGINT, self.exit_gracefully)
    signal.signal(signal.SIGTERM, self.exit_gracefully)

  def exit_gracefully(self, *args):
    self.kill_now = True

def main():
    target = Target()
    target.set_pos((182, -1))

    cone = TrafficCone()
    cone.set_pos((1.0,0))
    cone = TrafficCone()
    cone.set_pos((1.0,2))
    cone = TrafficCone()
    cone.set_pos((1.0,-2))

    trafficlight = TrafficLight()
    trafficlight.set_pos((160,-3))

    signal = SuggestedSpeedSignal(10)
    signal.set_pos((50, 4))
    bologna = GraphicObject("imgs/pictures/bologna.png", 35)
    bologna.set_pos((67,12))
    signal = SuggestedSpeedSignal(90)
    signal.set_pos((96, 4))
    super = GraphicObject("imgs/pictures/superstrada.png", 5)
    super.set_pos((100,6))

    vehicle = Vehicle()
    vehicle.set_screen_here()
    vehicle.set_pos_ang((0,-1,0))

    agent = Agent(vehicle)

    killer = GracefulKiller()
    while not killer.kill_now and World().loop:
        agent.compute()
        action = agent.get_action()

        vehicle.set_screen_here()
        vehicle.control([action[0], action[1]])

        World().update()

    agent.terminate()
    World().exit()

main()