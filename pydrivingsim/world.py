# Authors : Gastone Pietro Rosati Papini
# Date    : 09/08/2022
# License : MIT

import pygame

class Singleton(type):
    _instances = {}
    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]

class World(metaclass=Singleton):
    __metadata = {
        "render_fps": 50,
        "world_size": 400,              # [m] this dimension is maapped on the width of the screen
        "screen_size": ( 1000, 800 ),
        "world_in_screen": 50,
        "dt": 0.001
    }
    def __init__(self):
        self.loop = 1

        pygame.init()
        pygame.display.init()
        self.screen = pygame.display.set_mode( (self.__metadata["screen_size"][0], self.__metadata["screen_size"][1]) )
        self.backgorund = pygame.image.load("imgs/bg.jpeg")

        # Video information
        self.scaling_factor = self.__metadata["screen_size"][0] / self.__metadata["world_in_screen"]

        # Simulation information
        self.sim_call_freq = (1 / self.__metadata["dt"]) / self.__metadata["render_fps"]
        self.num_of_step = 0
        self.clock = pygame.time.Clock()
        self.time = 0

        self.set_world_pos((0,0))
        self.bg_pos=(-500,-1725)

        self.obj_list = []

    def set_world_pos(self, pos):
        self.world_pos = ( pos[0] * self.scaling_factor - self.__metadata["screen_size"][0] / 2 , pos[1] * self.scaling_factor - self.__metadata["screen_size"][1] / 2 )

    def get_world_pos(self):
        return self.world_pos

    def get_dt(self):
        return self.__metadata["dt"]

    def add(self, object):
        self.obj_list.append(object)

    def _render(self):
        self.screen.blit(self.backgorund, (self.bg_pos[0]-self.world_pos[0],self.bg_pos[1]-self.world_pos[1]))
        for obj in self.obj_list:
            obj.render()

        pygame.event.pump()
        self.clock.tick(self.__metadata["render_fps"])
        pygame.display.flip()


    def update(self):
        self.time += self.__metadata["dt"]
        self.num_of_step += 1
        if self.num_of_step >= self.sim_call_freq:
            self._render()
            self.num_of_step = 0

        for obj in self.obj_list:
            obj.compute()

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.loop = 0

    def exit(self):
        pygame.display.quit()
        pygame.quit()
        exit()