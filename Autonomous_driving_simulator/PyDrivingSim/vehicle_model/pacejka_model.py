from math import exp, sin, cos, atan

def pacejka_model(kappa, Fz, alpha, gamma, pacejka_params):

    # ----------------------------------------------------------------
    ## Function purpose: compute wheel forces and torques using Pacejka Model
    # ----------------------------------------------------------------

    # Pacejka Model
    # Inputs of the model:
    #   - kappa: longitudinal slip [-]
    #   - Fz:    vertical tire load [N]
    #   - alpha: side slip angle [rad]
    #   - gamma: camber angle [rad]
    
    # Outputs of the model:
    #   - Fx:    longitudinal force [N] 
    #   - Fy:    lateral force [N]
    #   - Mz:    aligning torque [Nm]
  
    
    # -------------------------------------
    ## Extract Pacejka fitted coefficients
    # -------------------------------------
    
    # Nominal vertical tire load
    Fz0  = pacejka_params.Fz0
    
    # Pure longitudinal force coefficients
    pCx1 = pacejka_params.pCx1
    pDx1 = pacejka_params.pDx1
    pDx2 = pacejka_params.pDx2
    pDx3 = pacejka_params.pDx3
    pEx1 = pacejka_params.pEx1
    pEx2 = pacejka_params.pEx2
    pEx3 = pacejka_params.pEx3
    pEx4 = pacejka_params.pEx4
    pHx1 = pacejka_params.pHx1
    pHx2 = pacejka_params.pHx2
    pKx1 = pacejka_params.pKx1
    pKx2 = pacejka_params.pKx2
    pKx3 = pacejka_params.pKx3
    pVx1 = pacejka_params.pVx1
    pVx2 = pacejka_params.pVx2
    
    # Combined longitudinal force coefficients
    rBx1 = pacejka_params.rBx1
    rBx2 = pacejka_params.rBx2
    rCx1 = pacejka_params.rCx1
    rEx1 = pacejka_params.rEx1
    rEx2 = pacejka_params.rEx2
    rHx1 = pacejka_params.rHx1
    
    # Pure lateral force coefficients
    pCy1 = pacejka_params.pCy1
    pDy1 = pacejka_params.pDy1
    pDy2 = pacejka_params.pDy2
    pDy3 = pacejka_params.pDy3
    pEy1 = pacejka_params.pEy1
    pEy2 = pacejka_params.pEy2
    pEy3 = pacejka_params.pEy3
    pEy4 = pacejka_params.pEy4
    pHy1 = pacejka_params.pHy1
    pHy2 = pacejka_params.pHy2
    pHy3 = pacejka_params.pHy3
    pKy1 = pacejka_params.pKy1
    pKy2 = pacejka_params.pKy2
    pKy3 = pacejka_params.pKy3
    pVy1 = pacejka_params.pVy1
    pVy2 = pacejka_params.pVy2
    pVy3 = pacejka_params.pVy3
    pVy4 = pacejka_params.pVy4
    
    # Combined lateral force coefficients
    rBy1 = pacejka_params.rBy1
    rBy2 = pacejka_params.rBy2
    rBy3 = pacejka_params.rBy3
    rBy4 = pacejka_params.rBy4
    rCy1 = pacejka_params.rCy1
    rEy1 = pacejka_params.rEy1
    rEy2 = pacejka_params.rEy2
    rHy1 = pacejka_params.rHy1
    rHy2 = pacejka_params.rHy2
    rVy1 = pacejka_params.rVy1
    rVy2 = pacejka_params.rVy2
    rVy3 = pacejka_params.rVy3
    rVy4 = pacejka_params.rVy4
    rVy5 = pacejka_params.rVy5
    rVy6 = pacejka_params.rVy6
    
    # Pure slef-aligning torque coefficients
    qBz1 = pacejka_params.qBz1
    qBz2 = pacejka_params.qBz2
    qBz3 = pacejka_params.qBz3
    qBz4 = pacejka_params.qBz4
    qBz5 = pacejka_params.qBz5
    qBz9 = pacejka_params.qBz9
    qBz10 = pacejka_params.qBz1
    qCz1 = pacejka_params.qCz1
    qDz1 = pacejka_params.qDz1
    qDz2 = pacejka_params.qDz2
    qDz3 = pacejka_params.qDz3
    qDz4 = pacejka_params.qDz4
    qDz6 = pacejka_params.qDz6
    qDz7 = pacejka_params.qDz7
    qDz8 = pacejka_params.qDz8
    qDz9 = pacejka_params.qDz9
    qEz1 = pacejka_params.qEz1
    qEz2 = pacejka_params.qEz2
    qEz3 = pacejka_params.qEz3
    qEz4 = pacejka_params.qEz4
    qEz5 = pacejka_params.qEz5
    qHz1 = pacejka_params.qHz1
    qHz2 = pacejka_params.qHz2
    qHz3 = pacejka_params.qHz3
    qHz4 = pacejka_params.qHz4
    R0   = pacejka_params.R0
    

    # -------------------------------------
    ## Pacejka equations
    # -------------------------------------
    
    Fz01 = Fz0           # Nominal Load
    dfz = Fz / Fz01 - 1  # dfz  = (Fz - Fz0)/Fz0
    
    # Pure longitudinal force parameters
    SHx = dfz * pHx2 + pHx1
    SVx = Fz * (dfz * pVx2 + pVx1)
    kappa__x = kappa + SHx 
    Cx = pCx1*1.3
    mu__x = (dfz * pDx2 + pDx1) * (-pDx3 * gamma ** 2 + 1)
    Dx = mu__x * Fz
    Kxk = Fz * (dfz * pKx2 + pKx1) * exp(-(pKx3 * dfz))
    Ex = (dfz ** 2 * pEx3 + dfz * pEx2 + pEx1) * (1 - pEx4)
    Bx = (Kxk / Cx) / Dx
    gamma__s = gamma
    
    # Combined longitudinal force parameters
    SHxa = rHx1
    Bxa = rBx1 * (kappa ** 2 * rBx2 ** 2 + 1) ** (-0.1e1 / 0.2e1)
    Cxa = rCx1
    Dxa = 0.1e1 / cos(Cxa * atan((Bxa * SHxa)))
    Gxa = Dxa * cos(Cxa * atan((Bxa * (alpha + SHxa))))
    
    # Pure lateral force parameters
    SHy = dfz * pHy2 + pHy3 * gamma__s + pHy1
    SVy = Fz * (pVy1 + pVy2 * dfz + (dfz * pVy4 + pVy3) * gamma__s)
    alpha__y = alpha + SHy
    Cy = pCy1
    mu__y = (dfz * pDy2 + pDy1) * (-pDy3 * gamma__s ** 2 + 1)
    Dy = mu__y * Fz
    Ey = (dfz * pEy2 + pEy1) * (-pEy4 * gamma__s - pEy3 + 1)
    Kya = Fz01 * pKy1 * sin(0.2e1 * atan((Fz / Fz01 / pKy2))) * (1 - pKy3 * abs(gamma__s))
    By = (Kya / Cy) / Dy
    gamma__z = gamma
    
    # Combined lateral force parameters
    SHyk = rHy1
    DVyk = mu__y * Fz * (dfz * rVy2 + gamma * rVy3 + rVy1) * (alpha ** 2 * rVy4 ** 2 + 1) ** (-0.1e1 / 0.2e1)
    SVyk = DVyk * sin(rVy5 * atan((rVy6 * kappa)))
    Byk = rBy1 * (1 + rBy2 ** 2 * (alpha - rBy3) ** 2) ** (-0.1e1 / 0.2e1)
    Cyk = rCy1
    Dyk = 0.1e1 / cos(Cyk * atan((Byk * SHyk)))
    Gyk = Dyk * cos(Cyk * atan((Byk * (kappa + SHyk))))

    # Pure self-aligning torque parameters
    SHf = SHy + SVy / Kya
    SHt = qHz1 + qHz2 * dfz + (dfz * qHz4 + qHz3) * gamma__z
    alpha__t = alpha + SHt
    alpha__r = alpha + SHf
    Bt = (dfz ** 2 * qBz3 + dfz * qBz2 + qBz1) * (1 + qBz4 * gamma__z + qBz5 * abs(gamma__z))
    Ct = qCz1
    Dt = Fz * (dfz * qDz2 + qDz1) * (qDz4 * gamma__z ** 2 + qDz3 * gamma__z + 1) * R0 / Fz0
    Et = (dfz ** 2 * qEz3 + dfz * qEz2 + qEz1) * (0.1e1 + (qEz5 * gamma__z + qEz4) * atan((Bt * Ct * alpha__t)))
    Br = By * Cy * qBz10 + qBz9
    Dr = Fz * (qDz6 + qDz7 * dfz + (dfz * qDz9 + qDz8) * gamma__z) * R0

    
    # -------------------------------------
    ## Outputs
    # -------------------------------------

    # Pure and combined longitudinal force
    Fx0 = (-Dx * sin(Cx * atan(-Bx * kappa__x + Ex * (Bx * kappa__x - atan(Bx * kappa__x)))) + SVx)
    Fx_comb =  Fx0* Gxa
    offsetFx = (Fz * (-0.281372732980853925e4 + Fz * 0.810191533417750187e0) * sin(atan(exp(Fz * (-0.616138223684905249e-3) + 0.548143673871933856e0) * (Fz * (-0.101430342064303437e-1) + 0.480851687881085454e5) / (-0.281372732980853925e4 + Fz * 0.810191533417750187e0) * (Fz * 0.101894089591398932e-5 - 0.552431757689196754e-4) * 0.693990264255749834e0 + (Fz ** 2 * (-0.333165990314313833e-6) + Fz * 0.350069496442759621e-3 + 0.865566227723819082e-1) * (exp(Fz * (-0.616138223684905249e-3) + 0.548143673871933856e0) * (Fz * (-0.101430342064303437e-1) + 0.480851687881085454e5) / (-0.281372732980853925e4 + Fz * 0.810191533417750187e0) * (Fz * 0.101894089591398932e-5 - 0.552431757689196754e-4) * (-0.693990264255749834e0) - atan(exp(Fz * (-0.616138223684905249e-3) + 0.548143673871933856e0) * (Fz * (-0.101430342064303437e-1) + 0.480851687881085454e5) / (-0.281372732980853925e4 + Fz * 0.810191533417750187e0) * (Fz * 0.101894089591398932e-5 - 0.552431757689196754e-4) * (-0.693990264255749834e0)))) * 0.144094240439009846e1) * 0.112404512366744451e-2 + Fz * (Fz * (-0.261373983233011906e-1) - 0.539868736564886476e2) * 0.112404512366744451e-2) / cos(atan(0.293163545351097649e-1) * 0.926013692178949799e0) * cos(atan(-0.293163545351097649e-1) * 0.926013692178949799e0) 

    # Pure and combined lateral force
    Fy0 = -Dy * sin(Cy * atan(-By * alpha__y + Ey * (By * alpha__y - atan(By * alpha__y)))) + SVy
    Fy_comb = Fy0  * Gyk + SVyk
    offsetFy = Fz * (-0.240954039813793634e4 + Fz * 0.274390567365253968e0) * sin(atan(sin(0.2e1 * atan(Fz * 0.110511927043874963e-2)) * (abs(0) * 0.134159743861844283e1 - 1) / Fz / (-0.240954039813793634e4 + Fz * 0.274390567365253968e0) * (Fz * (-0.132636164465592824e-5) - 0.371083630262798898e-2) * (-0.152511103219044525e8) + (0.729166688663670237e-1 + Fz * (-0.365078573864376527e-4)) * (sin(0.2e1 * atan(Fz * 0.110511927043874963e-2)) * (abs(0) * 0.134159743861844283e1 - 1) / Fz / (-0.240954039813793634e4 + Fz * 0.274390567365253968e0) * (Fz * (-0.132636164465592824e-5) - 0.371083630262798898e-2) * 0.152511103219044525e8 - atan(sin(0.2e1 * atan(Fz * 0.110511927043874963e-2)) * (abs(0) * 0.134159743861844283e1 - 1) / Fz / (-0.240954039813793634e4 + Fz * 0.274390567365253968e0) * (Fz * (-0.132636164465592824e-5) - 0.371083630262798898e-2) * 0.152511103219044525e8))) * 0.154027309068454099e1) * 0.112404512366744451e-2 + Fz * (0.781490003250828664e2 + Fz * (-0.401680086940341061e-1)) * 0.112404512366744451e-2 + Fz * (0.509629360051086987e6 + Fz * (-0.580349220782825483e2)) * sin(atan(0.0e0) * 0.906119916069003523e-1) * 0.126347744004056056e-5 

    # Pure self-aligning torque
    Mz0 = Dr * ((Br ** 2 * alpha__r ** 2 + 1) ** (-0.1e1 / 0.2e1)) * cos(alpha)
    Mz_comb = -((-Dy * sin(Cy * atan(-By * alpha__y + Ey * (By * alpha__y - atan(By * alpha__y)))) + SVy) * Gyk + SVyk) * Dt * cos(Ct * atan(-Bt * alpha__t + Et * (Bt * alpha__t - atan(Bt * alpha__t)))) * cos(alpha) + Mz0
    offsetMz0 = (Fz * (-0.240954039813793634e4 + Fz * 0.274390567365253968e0) * sin(atan(sin(0.2e1 * atan(Fz * 0.110511927043874963e-2)) * (abs(0) * 0.134159743861844283e1 - 1) / Fz / (-0.240954039813793634e4 + Fz * 0.274390567365253968e0) * (Fz * (-0.132636164465592824e-5) - 0.371083630262798898e-2) * (-0.152511103219044525e8) + (0.729166688663670237e-1 + Fz * (-0.365078573864376527e-4)) * (sin(0.2e1 * atan(Fz * 0.110511927043874963e-2)) * (abs(0) * 0.134159743861844283e1 - 1) / Fz / (-0.240954039813793634e4 + Fz * 0.274390567365253968e0) * (Fz * (-0.132636164465592824e-5) - 0.371083630262798898e-2) * 0.152511103219044525e8 - atan(sin(0.2e1 * atan(Fz * 0.110511927043874963e-2)) * (abs(0) * 0.134159743861844283e1 - 1) / Fz / (-0.240954039813793634e4 + Fz * 0.274390567365253968e0) * (Fz * (-0.132636164465592824e-5) - 0.371083630262798898e-2) * 0.152511103219044525e8))) * 0.154027309068454099e1) * 0.112404512366744451e-2 + Fz * (0.781490003250828664e2 + Fz * (-0.401680086940341061e-1)) * 0.112404512366744451e-2) * Fz * (0.224309955325285813e3 + Fz * (-0.549111816154102678e-1)) * cos(atan(-(Fz ** 2 * abs(0) * 0.219500142448391398e-5 + 0.589923028704022467e1 + abs(0) * Fz * (-0.241301554085827930e-2) + (abs(0) * (-0.166097760625274660e1)) + Fz ** 2 * (-0.779590214501757490e-5) + Fz * 0.857021449786109918e-2) * (-0.299697690075865792e-2 + Fz * (-0.862586787573066365e-5)) + (-0.117925961287417191e1 + Fz ** 2 * atan((Fz ** 2 * abs(0) * 0.173726997801674199e1 + 0.466904283376112022e7 + abs(0) * Fz * (-0.190982083604184959e4) + (abs(0) * (-0.131460804412892833e7)) + Fz ** 2 * (-0.617019496981862137e1) + Fz * 0.678303721638747720e4) * (-0.266624251789853561e1 + Fz * (-0.767395160043653126e-2)) * 0.237313360298639370e-8) * (-0.705810235338949284e-6) + atan((Fz ** 2 * abs(0) * 0.173726997801674199e1 + 0.466904283376112022e7 + abs(0) * Fz * (-0.190982083604184959e4) + (abs(0) * (-0.131460804412892833e7)) + Fz ** 2 * (-0.617019496981862137e1) + Fz * 0.678303721638747720e4) * (-0.266624251789853561e1 + Fz * (-0.767395160043653126e-2)) * 0.237313360298639370e-8) * Fz * 0.941721905257777124e-3 + atan((Fz ** 2 * abs(0) * 0.173726997801674199e1 + 0.466904283376112022e7 + abs(0) * Fz * (-0.190982083604184959e4) + (abs(0) * (-0.131460804412892833e7)) + Fz ** 2 * (-0.617019496981862137e1) + Fz * 0.678303721638747720e4) * (-0.266624251789853561e1 + Fz * (-0.767395160043653126e-2)) * 0.237313360298639370e-8) * (-0.194289083926614176e0) + Fz ** 2 * (-0.428399520995642626e-5) + Fz * 0.571588782542656153e-2) * ((Fz ** 2 * abs(0) * 0.219500142448391398e-5 + 0.589923028704022467e1 + abs(0) * Fz * (-0.241301554085827930e-2) + (abs(0) * (-0.166097760625274660e1)) + Fz ** 2 * (-0.779590214501757490e-5) + Fz * 0.857021449786109918e-2) * (-0.299697690075865792e-2 + Fz * (-0.862586787573066365e-5)) - atan((Fz ** 2 * abs(0) * 0.219500142448391398e-5 + 0.589923028704022467e1 + abs(0) * Fz * (-0.241301554085827930e-2) + (abs(0) * (-0.166097760625274660e1)) + Fz ** 2 * (-0.779590214501757490e-5) + Fz * 0.857021449786109918e-2) * (-0.299697690075865792e-2 + Fz * (-0.862586787573066365e-5))))) * 0.167097884314218659e1) * cos(0.0e0) * (-0.288830942793272139e-6) + Fz * (-0.125523877321407813e2 + Fz * 0.171847774709159469e-1) * cos(0.0e0) * 0.256956715270377836e-3

    # -------------------------------------
    ## Computation of the total forces Fx, Fy and moment Mz
    # -------------------------------------
    
    Fx = Fx_comb - offsetFx
    Fy = Fy_comb - offsetFy
    Mz = Mz_comb - offsetMz0

    return Fx, Fy, Mz

