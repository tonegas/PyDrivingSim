# Authors : Gastone Pietro Rosati Papini
# Date    : 09/08/2022
# License : MIT

import pygame
import random

# red then green no stop
#random.seed(10)
# stop with red
#random.seed(1)

from pydrivingsim import VirtualObject, World

class TrafficLightSprite(pygame.sprite.Sprite):
    def __init__(self, trafficlight):
        super().__init__()
        folder = "imgs/trafficlight/"
        img_list = [folder+"trafficlight_green.png", folder+"trafficlight_yellow.png", folder+"trafficlight_red.png"]
        self.image_fix = []
        for i,img in enumerate(img_list):
            sprite = pygame.image.load(img).convert_alpha()
            w, h = sprite.get_size()
            scale = (World().scaling_factor * trafficlight.scale) / w
            self.image_fix.append(pygame.transform.smoothscale(sprite, (int(w * scale), int(h * scale))))

        self.image = self.image_fix[0]
        self.rect = self.image_fix[0].get_rect()
        self.size = self.image_fix[0].get_size()
        self.trafficlight = trafficlight

    def update(self) -> None:
        self.rect.center = [
            (self.trafficlight.pos[0] - World().get_world_pos()[0]) * World().scaling_factor + World().screen_world_center[0],
            (World().get_world_pos()[1] - self.trafficlight.pos[1]) * World().scaling_factor + World().screen_world_center[1]
        ]
        self.image = self.image_fix[self.trafficlight.state]

class TrafficLight(VirtualObject):
    __metadata = {
        "dt": 0.1
    }
    def __init__( self ):
        super().__init__(self.__metadata["dt"])
        # Sprite
        self.scale = 0.7
        self.trafficlight = TrafficLightSprite(self)
        self.group = pygame.sprite.Group()
        self.group.add(self.trafficlight)

        self.pos = (0,0)
        self.time_phases = (8,3,8)
        self.time_past_switch = 0

        self.clock = None
        self.state = 0
        self.reset()

    def set_pos(self, point: tuple):
        self.pos = point

    def set_time_phases(self, time_phases: tuple):
        self.time_phases = time_phases

    def reset( self ):
        #Initial condition of the vehicle
        self.state = random.randint(0, 2)
        self.time_past_switch = random.random()*self.time_phases[self.state]

    def object_freq_compute(self):
        self.time_past_switch += self.__metadata["dt"]
        if self.time_past_switch >= self.time_phases[self.state]:
            self.state = divmod(self.state + 1, 3)[1]
            self.time_past_switch = 0

    def render( self ):
        self.trafficlight.update()
        self.group.draw(World().screen)

    def get_state(self):
        return self.state