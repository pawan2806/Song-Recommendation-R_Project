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

def loadPlaylistFeatures(playlist_id,audioDictList):
    try:
        badshah = spt.playlist_items(playlist_id=playlist_id)  
        songIds = []
        songIdName = {}  #Dictionary mapping ID to Name, used ahead
        for item in badshah['items']:
            # print(item)
            songIds.append(item['track']['id'])
            songIdName[item['track']['id']] = item['track']['name'] 
        print(songIds)
        # df = pd.DataFrame(columns = ['songID','danceability','energy','key','loudness','mode','speechiness','acousticness','instrumentalness','liveness','valence','tempo'])
        print(len(songIds))
        audioFeatures = spt.audio_features(songIds)
        print(audioFeatures)
        for song in audioFeatures:
            tempDict={}
            tempDict['songName'] = songIdName[song['id']]
            tempDict['songID'] = song['id']
            tempDict['danceability'] = song['danceability']
            tempDict['energy'] = song['energy']
            tempDict['key'] = song['key']
            tempDict['loudness'] = song['loudness']
            tempDict['mode'] = song['mode']
            tempDict['speechiness'] = song['speechiness']
            tempDict['acousticness'] = song['acousticness']
            tempDict['instrumentalness'] = song['instrumentalness']
            tempDict['liveness'] = song['liveness']
            tempDict['valence'] = song['valence']
            tempDict['tempo'] = song['tempo']
            audioDictList.append(tempDict)
            pass
            # print(items)
        return audioDictList
    except Exception as e:
        print(e)

try:
    audioDictList=[]
    audioDictList = loadPlaylistFeatures("37i9dQZF1DXdctHW27fX32",audioDictList=audioDictList) #This is Badshah
    audioDictList = loadPlaylistFeatures("37i9dQZF1DZ06evO2uagOI",audioDictList=audioDictList) #This is KK
    # audioDictList = loadPlaylistFeatures("37i9dQZF1DZ06evO2uagOI",audioDictList=audioDictList) #This is KK
    df = pd.DataFrame(audioDictList)
    print(df)
    df.to_csv('songFeatures.csv')
except Exception as e:
    print(e)

