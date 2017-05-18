; Turn cosmic radiation into a random number.
random:
    lda last_random_value
    rol
    adc #0
    adc vicreg_rasterhi
    sta last_random_value
    rts
