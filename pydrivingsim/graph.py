import pygame
import math

from pydrivingsim import VirtualObject, World

class GraphNodeSprite(pygame.sprite.Sprite):
    def __init__(self, graph, index):
        super().__init__()
        self.graph = graph    # graph containing 23 nodes
        self.index = index    # index of the node [0..22]

        # draw one node
        radius = 3
        size = radius * 2 + 2
        self.image = pygame.Surface((size, size), pygame.SRCALPHA)
        pygame.draw.circle(self.image, (255, 0, 0), (size // 2, size // 2), radius)
        self.rect = self.image.get_rect()

    def update(self) -> None:
        # disable sprite if there are not enough points
        if self.index >= len(self.graph.points_world):
            self.rect.center = (-1000, -1000) #center out of the screen
            return

        Xw, Yw = self.graph.points_world[self.index]

        # transform world -> screen
        world = World()
        X_ref, Y_ref = world.get_world_pos()
        s  = world.scaling_factor
        cx = world.screen_world_center[0]
        cy = world.screen_world_center[1]

        x_screen = (Xw - X_ref) * s + cx
        y_screen = (Y_ref - Yw) * s + cy

        self.rect.center = (x_screen, y_screen)


class Graph(VirtualObject):
    __metadata = { "dt": 0.1 }

    def __init__(self):
        super().__init__(self.__metadata["dt"])

        self.points_world = []

        # group of nodes
        self.group = pygame.sprite.Group()
        self.max_points = 23
        for i in range(self.max_points):
            sprite = GraphNodeSprite(self, i)
            self.group.add(sprite)

    def set_points_world(self, points):
        self.points_world = list(points[:self.max_points])

    def render(self):
        # draw circles
        self.group.update()
        self.group.draw(World().screen)

        # draw arcs
        if len(self.points_world) >= 2:
            world = World()
            screen = world.screen
            X_ref, Y_ref = world.get_world_pos()
            s  = world.scaling_factor
            cx = world.screen_world_center[0]
            cy = world.screen_world_center[1]

            pixel_points = []
            for (Xw, Yw) in self.points_world:
                x_screen = (Xw - X_ref) * s + cx
                y_screen = (Y_ref - Yw) * s + cy
                pixel_points.append((x_screen, y_screen))

            for i in range(len(pixel_points) - 1):
                x1, y1 = pixel_points[i]
                x2, y2 = pixel_points[i+1]
                pygame.draw.aaline(screen, (200, 0, 0), (x1, y1), (x2, y2))
