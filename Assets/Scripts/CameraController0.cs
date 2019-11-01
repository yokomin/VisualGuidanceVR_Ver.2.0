using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController0 : MonoBehaviour
{
    void Start()
    {
        UnityEngine.XR.InputTracking.disablePositionalTracking = true;
        transform.localPosition = Vector3.zero;
        transform.localRotation = Quaternion.identity;
    }
}
