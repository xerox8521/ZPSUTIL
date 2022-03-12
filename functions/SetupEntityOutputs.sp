void SetupEntityOutputs()
{
    HookEntityOutput("trigger_capturepoint_zp", "m_OnZombieCaptureStart", OnCaptureStart);
    HookEntityOutput("trigger_capturepoint_zp", "m_OnHumanCaptureStart", OnCaptureStart);
    HookEntityOutput("trigger_capturepoint_zp", "m_OnZombieCaptureCompleted", OnCaptureEnd);
    HookEntityOutput("trigger_capturepoint_zp", "m_OnHumanCaptureCompleted", OnCaptureEnd);
}