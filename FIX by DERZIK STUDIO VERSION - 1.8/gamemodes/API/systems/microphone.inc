forward OnPlayerVoice(int playerid, int receiverid, bool bText, float distance);

public OnPlayerVoice(int playerid, int receiverid, bool bText, float distance) {
    if (!bText) {
        // Voice communication
        if (receiverid == BROADCAST_TO_ALL) {
            // Send voice to all players
            SampVoice_SendVoiceToAll(playerid, distance);
        } else {
            // Send voice to specific player
            SampVoice_SendVoiceToPlayer(playerid, receiverid, distance);
        }
    } else {
        // Text communication
        // Handle text communication here
    }
}