import pygame
import random

from pydrivingsim import VirtualObject, World

class RockSprite(pygame.sprite.Sprite):
    def __init__(self, rock_obstacle):
        super().__init__()
        img = "imgs/rock.png"
        self.image_fix = []
        self.sprite = pygame.image.load(img).convert_alpha()
        w, h = self.sprite.get_size()
        scale_x = (World().scaling_factor * rock_obstacle.len) / w
        scale_y = (World().scaling_factor * rock_obstacle.width) / h

        new_w = max(1, int(w * scale_x))
        new_h = max(1, int(h * scale_y))

        self.image_fix.append(
            pygame.transform.smoothscale(self.sprite, (new_w, new_h))
        )
        self.image = self.image_fix[0]
        self.rect = self.image_fix[0].get_rect()
        self.size = self.image_fix[0].get_size()
        self.rock_obstacle = rock_obstacle
        
    def resize(self, len, width):
        w, h = self.sprite.get_size()
        s = World().scaling_factor

        scale_x = (s * len) / w
        scale_y = (s * width) / h

        new_w = max(1, int(w * scale_x))
        new_h = max(1, int(h * scale_y))

        scaled = pygame.transform.smoothscale(self.sprite, (new_w, new_h))

        if self.image_fix:
            self.image_fix[0] = scaled
        else:
            self.image_fix.append(scaled)

        self.image = self.image_fix[0]
        self.rect = self.image.get_rect()
        self.size = self.image.get_size()

    def update(self) -> None:
        self.rect.center = [
            (self.rock_obstacle.pos[0] - World().get_world_pos()[0]) * World().scaling_factor + World().screen_world_center[0],
            (World().get_world_pos()[1] - self.rock_obstacle.pos[1]) * World().scaling_factor + World().screen_world_center[1]
        ]
        self.image = self.image_fix[self.rock_obstacle.state]

class Rock(VirtualObject):
    __metadata = {
        "dt": 0.1
    }
    def __init__( self ):
        super().__init__(self.__metadata["dt"])
        # Sprite
        self.size = 1 # 0.5
        self.state = 0
        self.pos = (0,0)
        self.len = 1.0
        self.width = 1.0
        self.rock = RockSprite(self)
        self.group = pygame.sprite.Group()
        self.group.add(self.rock)
        self.reset()

    def set_pos_size(self, point, len: float, width: float):
        self.pos = point
        self.len = len
        self.width = width
        self.rock.resize(len, width)

    def reset(self):
        self.state = 0

    def render( self ):
        self.rock.update()
        self.group.draw(World().screen)