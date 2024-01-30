# Authors : Gastone Pietro Rosati Papini
# Date    : 30/01/2024
# License : MIT

import pygame

from pydrivingsim import VirtualObject, World

class GraphicObjectSprite(pygame.sprite.Sprite):
    def __init__(self, graphicobject):
        super().__init__()
        self.image_fix = []
        if type(graphicobject.imgs) is list:
            for img in graphicobject.img:
                try:
                    sprite = pygame.image.load(img).convert_alpha()
                except:
                    sprite = pygame.image.load("imgs/error.png").convert_alpha()
                w, h = sprite.get_size()
                scale = (World().scaling_factor * graphicobject.scale) / w
                self.image_fix.append(pygame.transform.smoothscale(sprite, (int(w * scale), int(h * scale))))
        else:
            try:
                sprite = pygame.image.load(graphicobject.imgs).convert_alpha()
            except:
                sprite = pygame.image.load("imgs/error.png").convert_alpha()
            w, h = sprite.get_size()
            scale = (World().scaling_factor * graphicobject.scale) / w
            self.image_fix.append(pygame.transform.smoothscale(sprite, (int(w * scale), int(h * scale))))

        self.image = self.image_fix[0]
        self.rect = self.image_fix[0].get_rect()
        self.size = self.image_fix[0].get_size()
        self.graphicobject = graphicobject

    def update(self) -> None:
        self.rect.center = [
            (self.graphicobject.pos[0] - World().get_world_pos()[0]) * World().scaling_factor + World().screen_world_center[0],
            (World().get_world_pos()[1] - self.graphicobject.pos[1]) * World().scaling_factor + World().screen_world_center[1]
        ]
        self.image = self.image_fix[self.graphicobject.state]

class GraphicObject(VirtualObject):
    __metadata = {
        "dt": 0.1
    }
    def __init__( self, imgs, scale ):
        super().__init__(self.__metadata["dt"])
        # Sprite
        self.imgs = imgs
        self.scale = scale
        self.sprite = GraphicObjectSprite(self)
        self.group = pygame.sprite.Group()
        self.group.add(self.sprite)

        self.state = 0
        self.pos = (0,0)
        self.reset()

    def set_pos(self, point: tuple):
        self.pos = point

    def set_state(self, state):
        self.state = state

    def reset(self):
        self.state = 0

    def render( self ):
        self.sprite.update()
        self.group.draw(World().screen)