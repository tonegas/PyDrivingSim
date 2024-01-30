# Authors : Gastone Pietro Rosati Papini and Matteo Zumerle
# Date    : 30/01/2024
# License : MIT

import pygame
from pydrivingsim import VirtualObject, World

class SuggestedSpeedSignalSprite(pygame.sprite.Sprite):
    def __init__(self, segnale):
        super().__init__()

        folder = "imgs/suggestedspeedsignal/"
        img = folder + str(segnale.vel) + ".png"
        try:
            pygame.image.load(img)
        except:
            img = folder + "90.png"

        self.image_fix = []
        sprite = pygame.image.load(img).convert_alpha()
        w, h = sprite.get_size()
        scale = (World().scaling_factor * segnale.scale) / w
        self.image_fix.append(pygame.transform.smoothscale(sprite, (int(w * scale), int(h * scale))))

        self.image = self.image_fix[0]
        self.rect = self.image_fix[0].get_rect()
        self.size = self.image_fix[0].get_size()
        self.segnale = segnale

    def update(self) -> None:
        self.rect.center = [
            (self.segnale.pos[0] - World().get_world_pos()[0]) * World().scaling_factor + World().screen_world_center[0],
            (World().get_world_pos()[1] - self.segnale.pos[1]) * World().scaling_factor + World().screen_world_center[1]
        ]
        self.image = self.image_fix[self.segnale.state]

class SuggestedSpeedSignal(VirtualObject):
    __metadata = {
        "dt": 0.1
    }
    def __init__( self, vel ):
        super().__init__(self.__metadata["dt"])
        # Sprite
        self.scale = 3
        self.vel = vel
        self.signal = SuggestedSpeedSignalSprite(self)
        self.group = pygame.sprite.Group()
        self.group.add(self.signal)


        self.state = 0
        self.pos = (0,0)

    def set_pos(self, point: tuple):
        self.pos = point

    def render( self ):
        self.signal.update()
        self.group.draw(World().screen)