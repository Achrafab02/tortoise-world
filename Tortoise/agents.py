#! /usr/bin/python -*- coding: utf-8 -*-

import random

MANGE='eat'
BOIT='drink'
AVANCE='forward'
GAUCHE='left'
DROITE='right'

class ReflexBrain():

    def think( self, capteur ):
        from  matortue import think
        return think(capteur)
