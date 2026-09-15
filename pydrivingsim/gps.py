import pygame
import random

from pydrivingsim import VirtualObject

class GPS(VirtualObject):
    __metadata = {
        "dt": 0.1
    }
    def __init__(self, vehicle):
        super().__init__(self.__metadata["dt"])
        self.vehicle = vehicle
        self.x = 0.0
        self.y = 0.0
        self.psi = 0.0
        
    def update(self):
        self.x = self.vehicle.state[0]
        self.y = self.vehicle.state[1]
        self.psi = self.vehicle.state[2]