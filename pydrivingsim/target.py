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
        scale = (World().scaling_factor * 0.6) / w
        self.image_fix.append(pygame.transform.smoothscale(sprite, (int(w * scale), int(h * scale))))

        self.image = self.image_fix[0]
        self.rect = self.image_fix[0].get_rect()
        self.size = self.image_fix[0].get_size()
        self.target = target

    def update(self) -> None:
        self.rect.center = [
            self.size[0] / 2 + self.target.pos[0] * World().scaling_factor - World().get_world_pos()[0],
            self.target.pos[1] * World().scaling_factor - World().get_world_pos()[1]
        ]
        self.image = self.image_fix[self.target.state]


class Target(VirtualObject):
    __metadata = {
        "dt": 0.1
    }
    def __init__( self ):
        super().__init__(self.__metadata["dt"])
        # Sprite
        self.target = TargetSprite(self)
        self.group = pygame.sprite.Group()
        self.group.add(self.target)

        self.state = 0
        self.pos = (0,0)
        self.reset()

    def set_pos(self, point: tuple):
        self.pos = point

    def reset(self):
        self.state = 0

    def render( self ):
        self.target.update()
        self.group.draw(World().screen)