# Authors : Gastone Pietro Rosati Papini
# Date    : 09/08/2022
# License : MIT

from pydrivingsim import World

class VirtualObject():
    def __init__( self, dt ):
        # Simulation information
        assert dt >= World().get_dt()
        self.sim_call_freq = dt / World().get_dt()
        self.num_of_step = 0

        # Add the object to the world
        World().add(self)

    def compute(self):
        self.num_of_step += 1
        self.world_freq_compute()
        if self.num_of_step >= self.sim_call_freq:
            self.object_freq_compute()
            self.num_of_step = 0

    def world_freq_compute(self):
        pass

    def object_freq_compute(self):
        pass

    def render(self):
        pass

