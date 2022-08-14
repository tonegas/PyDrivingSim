from math import atan, tan

def perfect_ackermann_model(delta, params):

    # ----------------------------------------------------------------
    ## Function purpose: compute steering angles for front wheels, with 
    ##                   perfect Ackerman steering model
    # ----------------------------------------------------------------
    
    # Load vehicle data
    Lf = params.vehicle.Lf        
    Lr = params.vehicle.Lr                 
    Wf = params.vehicle.Wf       
    
    # Perfect Ackermann steering law
    delta_fr = atan( ( 2 * Lr + 2 * Lf ) * tan( delta ) / ( Wf * tan( delta ) + 2 * Lr + 2 * Lf ) )
    delta_fl = -atan( ( 2 * Lr + 2 * Lf ) * tan( delta ) / ( Wf * tan( delta ) - 2 * Lr - 2 * Lf ) )

    return delta_fr, delta_fl