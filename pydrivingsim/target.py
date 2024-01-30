# Authors : Gastone Pietro Rosati Papini
# Date    : 10/09/2023
# License : MIT

import pygame
import random

# red then green no stop
#random.seed(10)
# stop with red
#random.seed(1)

from pydrivingsim import VirtualObject, World

class TargetSprite(pygame.sprite.Sprite):
    def __init__(self, target):
        super().__init__()
        img = "imgs/target.png"
        self.image_fix = []
        sprite = pygame.image.load(img).convert_alpha()
        w, h = sprite.get_size()
        scale = (World().scaling_factor * target.scale) / w
        self.image_fix.append(pygame.transform.smoothscale(sprite, (int(w * scale), int(h * scale))))

        self.image = self.image_fix[0]
        self.rect = self.image_fix[0].get_rect()
        self.size = self.image_fix[0].get_size()
        self.target = target

    def update(self) -> None:
        self.rect.center = [
            (self.target.pos[0] - World().get_world_pos()[0]) * World().scaling_factor + World().screen_world_center[0] ,
            (World().get_world_pos()[1] - self.target.pos[1]) * World().scaling_factor + World().screen_world_center[1]
        ]
        self.image = self.image_fix[self.target.state]

class Target(VirtualObject):
    __metadata = {
        "dt": 0.1
    }
    def __init__( self ):
        super().__init__(self.__metadata["dt"])
        # Sprite
        self.scale = 0.6
        self.sprite = TargetSprite(self)
        self.group = pygame.sprite.Group()
        self.group.add(self.sprite)

        self.state = 0
        self.pos = (0,0)
        self.reset()

    def set_object(self, obj):
        self.obj = obj

    def set_pos(self, point: tuple):
        self.pos = point

    def reset(self):
        self.state = 0

    def render( self ):
        self.sprite.update()
        self.group.draw(World().screen)
        if abs(self.pos[0] - self.obj.pos[0]) < 1.0 and abs(self.pos[1] - self.obj.pos[1]) < 1.0:
            World().loop = 0