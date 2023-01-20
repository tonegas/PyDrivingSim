import pygame, math
import numpy as np

from pydrivingsim import VirtualObject, World

class ObstacleSprite(pygame.sprite.Sprite):
    def __init__(self, obstacle):
        super().__init__()
        self.obstacle = obstacle
        image = pygame.image.load("imgs/cone.png").convert_alpha()
        w, h = image.get_size()
        scale = (World().scaling_factor * 1.5) / w
        self.image_fix = pygame.transform.smoothscale(image, (int(w * scale), int(h * scale)))

        self.image = self.image_fix
        self.rect = self.image_fix.get_rect()
        self.size = self.image_fix.get_size()

    def update(self) -> None:
        self.rect.center = [
            self.size[0] / 2 + self.obstacle.pos[0] * World().scaling_factor - World().get_world_pos()[0],
            self.obstacle.pos[1] * World().scaling_factor - World().get_world_pos()[1]
        ]
        self.image = self.image_fix

class Obstacle(VirtualObject):
    __metadata = {
        "dt": 0.1
    }
    def __init__( self ):
        super().__init__(self.__metadata["dt"])
        # Sprite
        self.obstacle = ObstacleSprite(self)
        self.group = pygame.sprite.Group()
        self.group.add(self.obstacle)

        self.pos = (0,0)

        self.clock = None
        self.reset()

    def set_pos(self, point: tuple):
        self.pos = point

    def render( self ):
        self.obstacle.update()
        self.group.draw(World().screen)

    # def get_state(self):
    #     return self.state