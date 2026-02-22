import pygame
from pydrivingsim import VirtualObject, World

class RoadSegmentSprite(pygame.sprite.Sprite):
    def __init__(self, road_segment):
        super().__init__()
        
        # draw the roadSegment
        # for now, it just draws rectangles -> to do: implement texture
        if road_segment.type_id == 7: # Dirt
            color = (139, 69, 19) 
        else: # Asphalt (ID 6)
            color = (80, 80, 80)

        self.road_segment = road_segment
        
        w_pixel = int(World().scaling_factor * road_segment.length)
        h_pixel = int(World().scaling_factor * road_segment.width)
        
        self.image = pygame.Surface([w_pixel, h_pixel])
        self.image.fill(color)
        
        self.image.set_alpha(200) 

        self.rect = self.image.get_rect()

    def update(self) -> None:
        self.rect.center = [
            (self.road_segment.pos[0] - World().get_world_pos()[0]) * World().scaling_factor + World().screen_world_center[0],
            (World().get_world_pos()[1] - self.road_segment.pos[1]) * World().scaling_factor + World().screen_world_center[1]
        ]

class RoadSegment(VirtualObject):
    __metadata = {
        "dt": 0.1
    }
    def __init__(self, x, y, length, width, terrain_type="asphalt"):
        super().__init__(self.__metadata["dt"])
        self.pos = (x, y)
        self.length = length
        self.width = width
        
        if terrain_type == "dirt":
            self.type_id = 7
        else:
            self.type_id = 6

        self.sprite = RoadSegmentSprite(self)
        self.group = pygame.sprite.Group()
        self.group.add(self.sprite)

    # decomment if you want the roadSegments to be drawn
    #def render(self):
        #self.sprite.update()
        #self.group.draw(World().screen)