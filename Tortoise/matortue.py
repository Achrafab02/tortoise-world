#! /usr/bin/python -*- coding: utf-8 -*-

from agents import *
import random

def think(capteur):
    # CODE ICI
    return random.choice([MANGE, BOIT, GAUCHE, DROITE, AVANCE, AVANCE])
