using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    private Vector3 startPosition;

    void Awake(){
        startPosition = transform.position;
        UnityEngine.XR.InputTracking.disablePositionalTracking = true;
    }

    void Start()
    {
        transform.localPosition = startPosition;
        transform.localRotation = Quaternion.identity;
    }
}
