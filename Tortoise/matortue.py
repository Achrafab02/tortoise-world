#! /usr/bin/python -*- coding: utf-8 -*-

from agents import *

def think(capteur):
	return random.choice([MANGE, BOIT, GAUCHE, DROITE, AVANCE, AVANCE])