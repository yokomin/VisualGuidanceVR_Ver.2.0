using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraParentController : MonoBehaviour
{
    private Vector3 startLocalPosition;

    void Awake()
    {
        UnityEngine.XR.InputTracking.disablePositionalTracking = false;
    }
    void Start()
    {
        startLocalPosition = transform.localPosition;
        UnityEngine.XR.InputTracking.disablePositionalTracking = true;
        transform.parent.gameObject.transform.position -= startLocalPosition;
        transform.rotation = Quaternion.identity;
    }
}
