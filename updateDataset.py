import spotipy
import time
from IPython.core.display import clear_output
from spotipy import SpotifyClientCredentials, util
import json
import pandas as pd 
client_id='38caca3b2f7649799800f6fab1005d55'
client_secret='9f065fb6b6064cf6b9f25fecdc0640e7'
redirect_uri='your_url_to_redirect'
username = 'your_username_spotify_code'
scope = 'playlist-modify-public'


#Credentials to access the Spotify Music Data
spmanager = SpotifyClientCredentials(client_id,client_secret)
spt = spotipy.Spotify(client_credentials_manager=spmanager)

try:
    df = pd.read_csv("songFeatures.csv")
    songIdList = list(df["songID"])
    print(songIdList)
    counter = 0
    for id in songIdList:
        x = spt.track(id)
        # print(x)
        artist = x["artists"][0]["name"]
        # print(artist)
        df["artist"][counter] = artist
        counter = counter+1
    print(df)
    df.to_csv('songFeatures.csv')
except Exception as e:
    print(e)