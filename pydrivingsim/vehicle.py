# Authors : Gastone Pietro Rosati Papini
# Date    : 09/08/2022
# License : MIT

import pygame, math
import numpy as np

from vehicle_model.vehicle_params import VehicleParams
from vehicle_model.pacejka_params import PacejkaParam
from vehicle_model.vehicle_double_track_model import vehicle_double_track_model
from pydrivingsim import VirtualObject, World

class VehicleSprite(pygame.sprite.Sprite):
    def __init__(self, vehicle):
        super().__init__()
        self.vehicle = vehicle
        image = pygame.image.load("imgs/car.png").convert_alpha()
        w, h = image.get_size()
        scale = (World().scaling_factor * vehicle.vehicle.L) / w
        self.image_fix = pygame.transform.smoothscale(image, (int(w * scale), int(h * scale)))
        # Correct dimension of the vehicle but the picture is stretched
        # scalex = (World().scaling_factor * vehicle.vehicle.L) / w
        # scaley = (World().scaling_factor * vehicle.vehicle.Wf) / h
        # self.image_fix = pygame.transform.smoothscale(image, (int(w * scalex), int(h * scaley)))

        self.image = self.image_fix
        self.rect = self.image_fix.get_rect()
        self.size = self.image_fix.get_size()

    def update(self, state) -> None:
        self.image = pygame.transform.rotozoom(self.image_fix, math.degrees(state[2]), 1)
        rect = self.image.get_rect()
        rect_fix = self.image_fix.get_rect()
        self.rect.center = [
            (state[0] - World().get_world_pos()[0]) * World().scaling_factor + World().screen_world_center[0] - rect.w/2 + rect_fix.w/2,
            (World().get_world_pos()[1] - state[1]) * World().scaling_factor + World().screen_world_center[1] - rect.h/2 + rect_fix.h/2
        ]


class Vehicle(VirtualObject):
    __metadata = {
        "dt": 0.001
    }
    def __init__( self ):
        super().__init__(self.__metadata["dt"])

        self.vehicle = VehicleParams()
        self.pacejka = PacejkaParam()

        # Sprite
        self.car = VehicleSprite(self.vehicle)
        self.group = pygame.sprite.Group()
        self.group.add(self.car)

        self.clock = None
        self.state = None

        self.pos = (0, 0)
        self.action = (0,0)
        self.reset()

    def reset( self ):
        #Initial condition of the vehicle
        X = np.zeros(24)
        X[0] = 0
        X[1] = 0
        X[2] = 0
        X[6] = 906.97882  # [N] vertical force for the rear right wheel
        X[7] = 906.97882  # [N] vertical force for the rear left wheel
        X[8] = 638.09618  # [N] vertical force for the front right wheel
        X[9] = 638.09618  # [N] vertical force for the front left wheel

        self.t = 0
        self.dX = np.zeros(24)
        self.state = X
        self.pos = (self.state[0], self.state[1])

    def set_pos_ang(self, point_angle: tuple):
        self.state[0] = point_angle[0]
        self.state[1] = point_angle[1]
        self.state[2] = point_angle[2]

    def __discrete(self, x0, dt, dx0=None, actions=None):
        dx = np.asarray(self.__derivs_dynamics(x0, dx0, actions))
        x = x0 + dt * dx
        return x, dx

    def __derivs_dynamics(self, X, dX, actions):
        pedal_req = actions[0]
        delta_req = actions[1]
        next_dX, extra_params = vehicle_double_track_model(dX, X, pedal_req, delta_req, self.pacejka, self.vehicle)
        return next_dX

    def object_freq_compute(self):
        self.t = self.t + self.__metadata["dt"]
        next_state, next_dX = self.__discrete(self.state, self.__metadata["dt"], self.dX, self.action)

        self.state = next_state
        self.pos = (self.state[0], self.state[1])
        self.dX = next_dX # potrei cambiarlo in qualcosa del tipo (next_state - self.state)/dt

    def set_screen_here(self):
        World().set_world_pos((self.state[0],self.state[1]))

    def render( self ):
        self.car.update(self.state)
        self.group.draw(World().screen)

    def control(self, action):
        self.action = action

    def get_state(self):
        return self.state, self.dX