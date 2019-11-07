using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;

public class Aim : MonoBehaviour
{
    [SerializeField] private int LengthOfRay = 25;
    private LineRenderer lineRenderer;
    private Ray ray;
    public bool delete{ set; get; }
    public bool startFlag{ set; get; }

    private SteamVR_Action_Boolean actionToHaptic = SteamVR_Actions._default.InteractUI;
    private SteamVR_Action_Vibration haptic = SteamVR_Actions._default.Haptic;

    // Start is called before the first frame update
    void Start()
    {
        lineRenderer = GetComponent<LineRenderer>();
        lineRenderer.startWidth = 0.01f;
        lineRenderer.endWidth = 0.01f;
        delete = false;
        startFlag = false;
    }

    // Update is called once per frame
    void Update()
    {
        lineRenderer.SetPosition(0, transform.position);
        lineRenderer.SetPosition(1, transform.position + transform.forward * LengthOfRay);

        if (actionToHaptic.GetStateDown(SteamVR_Input_Sources.RightHand)) {
            ray = new Ray(transform.position, transform.forward);
            RaycastHit hit;
            if(Physics.Raycast(ray, out hit, Mathf.Infinity)) {
                if(hit.collider.tag == "target"){
                    hit.collider.gameObject.SetActive(false);
                    delete = true;
                } else if(hit.collider.tag == "Central"){
                    startFlag = true;
                }
            }
        }
    }
}
