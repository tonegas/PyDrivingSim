# Authors : Gastone Pietro Rosati Papini
# Date    : 09/08/2022
# License : MIT
import math
import signal

from pydrivingsim import World
from scenarios import BasicSpeedLimit, Scenario_BasicTL, OnlyVehicle, AutonomousVehicle, GetTheCoins

class GracefulKiller:
  kill_now = False
  def __init__(self):
    signal.signal(signal.SIGINT, self.exit_gracefully)
    signal.signal(signal.SIGTERM, self.exit_gracefully)

  def exit_gracefully(self, *args):
    self.kill_now = True

def main():
    # Enable this to test only single vehicle
    #av = OnlyVehicle()
    av = AutonomousVehicle()
    
    # choose the scenario
    Scenario_BasicTL(av) #straight road with the traffic light

    killer = GracefulKiller()
    while not killer.kill_now and World().loop:
        av.update()
        World().update()

    av.terminate()
    World().exit()

main()